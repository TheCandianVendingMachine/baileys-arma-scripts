#include "script_component.hpp"

params ["_flag", ["_excludedFactions", []]];

_flag setVariable [QGVAR(exclude), _excludedFactions, true];

private _act = [QGVAR(ChangeFlag), "Change Flag", "", FUNC(changeFlag), FUNC(canChangeFlag), {}, [], [-0.1, -0.3, -2.5], 3] call ace_interact_menu_fnc_createAction;
[_flag, 0, [], _act] call ace_interact_menu_fnc_addActionToObject;