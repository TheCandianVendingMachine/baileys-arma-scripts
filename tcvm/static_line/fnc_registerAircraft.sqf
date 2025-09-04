#include "script_component.hpp"

params ["_plane"];

_plane setVariable [QGVAR(enabled), true, true];
_plane setVariable [QGVAR(light), LIGHT_OFF_STR];
_plane setVariable [QGVAR(hookedTroops), []];

private _eh = _plane addEventHandler ["GetOut", {
    params ["_plane", "", "_unit", "", "_isEject"];
    if !(_plane getVariable [QGVAR(enabled), false]) exitWith {};
    if (local _plane && _isEject && { [_unit, _plane] call FUNC(isHookedUp) }) then {
        [_unit, _plane] call FUNC(ejectUnit);
    };
    [QGVAR(unhook), [_plane, _unit], _plane] call CBA_fnc_targetEvent;
}];
_plane setVariable [QGVAR(eh_getOut), _eh];
