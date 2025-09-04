#include "script_component.hpp"

PREP(ejectUnit);
PREP(registerAircraft);
PREP(registerParadropAction);
PREP(isCrew);
PREP(isHookedUp);
PREP(isSafeToJump);
PREP(lightStatus);

[QGVAR(paradrop), {
    params ["_plane"];
    if !(local _plane) exitWith {};
    if !(_plane getVariable [QGVAR(enabled), false]) exitWith {};

    if !(_plane call FUNC(isSafeToJump)) exitWith {
        ["ace_common_displayTextStructured", "It is not safe to jump at this altitude! Climb higher!", crew _plane] call CBA_fnc_targetEvent;
    };

    private _hookedUnits = _plane getVariable QGVAR(hookedTroops);
    private _sum = 0;
    {
        private _colour = _plane getVariable QGVAR(light);
        if (_colour isNotEqualTo LIGHT_COLOUR_GO) exitWith {};
        _sum = _sum + (1 + random 0.5);
        [{
            params ["_unit", "_plane"];
            _this call FUNC(ejectUnit);
        }, [_x, _plane], _sum] call CBA_fnc_waitAndExecute;
    } forEach _hookedUnits;
}] call CBA_fnc_addEventHandler;

[QGVAR(hookUp), {
    params ["_plane", "_unit"];
    if !(local _plane) exitWith {};
    if !(_plane getVariable [QGVAR(enabled), false]) exitWith {};

    private _unitsHooked = _plane getVariable QGVAR(hookedTroops);
    _unitsHooked pushBack _unit;
    _plane setVariable [QGVAR(hookedTroops), _unitsHooked, true];
}] call CBA_fnc_addEventHandler;

[QGVAR(unhook), {
    params ["_plane", "_unit"];
    if !(local _plane) exitWith {};
    if !(_plane getVariable [QGVAR(enabled), false]) exitWith {};

    private _unitsHooked = _plane getVariable QGVAR(hookedTroops);
    _plane setVariable [QGVAR(hookedTroops), _unitsHooked select {
        _x isNotEqualTo _unit
    }, true];
}] call CBA_fnc_addEventHandler;

[QGVAR(changeLight), {
    params ["_plane", "_colour"];
    if !(local _plane) exitWith {};
    if !(_plane getVariable [QGVAR(enabled), false]) exitWith {};

    _plane setVariable [QGVAR(light), _colour, true];
    ["ace_common_displayTextStructured", _plane call FUNC(lightStatus), crew _plane] call CBA_fnc_targetEvent;

    if (_colour isEqualTo LIGHT_OFF_STR) then {
        _plane setVariable [QGVAR(hookedTroops), [], true];
    };

    if (_colour isEqualTo LIGHT_GREEN_STR) then {
        [{
            [QGVAR(paradrop), _this] call CBA_fnc_localEvent;
        }, _plane, 1 + random 2] call CBA_fnc_waitAndExecute;
    };
}] call CBA_fnc_addEventHandler;

call FUNC(registerParadropAction);
