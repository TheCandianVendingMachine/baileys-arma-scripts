#include "script_component.hpp"

params ["_target", "_player", "_params"];
_params params ["_instigator", "_deadTime"];

private _detectiveSubActions = [];
_detectiveSubActions pushBack [[QGVAR(investigateDead_dna), "Scan for DNA", "", {
}, {
    params ["_target", "_player", "_params"];
    DNA_SCANNER in (items _player);
}, {}, [_instigator, _deadTime]] call ace_interact_menu_fnc_createAction, [], _target];

_detectiveSubActions