#include "script_component.hpp"

params ["_target", "_player", "_params"];

private _traitorSubActions = [];
_traitorSubActions pushBack [[QGVAR(investigateDead_burn), "Burn Body", "", {
    params ["_target", "_player", "_params"];
    _player setVariable [QGVAR(hasBurnItem), false];
    // burn baby burn
    [_target, 1.5] call ttt_f_burn;
    
    [{ hideBody _this; }, _target, 5] call CBA_fnc_waitAndExecute;
}, {
    params ["_target", "_player", "_params"];
    _player getVariable [QGVAR(hasBurnItem), false]
}, {}, []] call ace_interact_menu_fnc_createAction, [], _target];

_traitorSubActions