#include "script_component.hpp"
params ["_object", "_timeToDetonation", "_isExample"];

[_object] call FUNC(addActions);

if !(isServer) exitwith {};

private _nukeType = selectRandom GVAR(allTypes);
(GVAR(database) get _nukeType) params ["", "_yield", "_defuseOrder"];

_object setVariable [QGVAR(yield), _yield, true];
_object setVariable [QGVAR(defuseOrder), _defuseOrder, true];
_object setVariable [QGVAR(defuseIndex), 0, true];
_object setVariable [QGVAR(type), _nukeType, true];

_object setVariable [QGVAR(detonated), false, true];
_object setVariable [QGVAR(armed), true, true];
_object setVariable [QGVAR(isExample), _isExample, true];

_object setVariable [QGVAR(cutWires), [], true];
_object setVariable [QGVAR(wireOrder), [], true];

_object setVariable [QGVAR(alivePFH), [{
    params ["_args", "_handle"];
    _args params ["_object"];

    if !(alive _object) exitWith {
        [QGVAR(detonate), [_object]] call CBA_fnc_serverEvent;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

}, 1, [_object]] call CBA_fnc_addPerFrameHandler];

if !(_isExample) then {
    ["potato_safeStartOff", {
        _thisArgs params ["_object", "_timeToDetonation"];
        [{
            params ["_object"];
            [QGVAR(detonate), [_object]] call CBA_fnc_serverEvent;
        }, [_object], _timeToDetonation] call CBA_fnc_waitAndExecute;
    }, _this] call CBA_fnc_addEventHandlerArgs;
};

