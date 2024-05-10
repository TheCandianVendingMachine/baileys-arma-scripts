#include "script_component.hpp"

params ["_target", "_player", "_params"];

_params = _target getVariable [QGVAR(dna), [objNull, 0, "ERROR: NO NAME", 0, "", "NONE"]];
_params params ["_instigator", "_distance", "_name", "_deadTime", "_killedWith", "_affiliation"];

private _actions = [];

_actions pushBack [
    [QGVAR(investigateDead_info), "Get Information", "", FUNC(body_investigate), {true}, {}, [_name, _affiliation, _killedWith, _deadTime]] call ace_interact_menu_fnc_createAction,
    [],
    _target
];

_actions pushBack [
    [QGVAR(investigateDead_detective), "Detective Actions", "", {}, { [_player] call FUNC(isDetective) }, FUNC(action_detectiveBody), [_instigator, _deadTime] ] call ace_interact_menu_fnc_createAction,
    [],
    _target
];

_actions pushBack [
    [QGVAR(investigateDead_traitor), "Traitor Actions", "", {}, { [_player] call FUNC(isTraitor) }, FUNC(action_traitorBody)] call ace_interact_menu_fnc_createAction,
    [],
    _target
];
    
_actions
