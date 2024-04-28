#include "script_component.hpp"
params ["_object"];
private _hasActions = _object getVariable [QGVAR(hasActions), false];
if (_hasActions) exitWith {};
private _determineTypeAction = [QGVAR(determineType), "Determine Bomb Type", "", {
    private _isPlayerEOD = _player getVariable [QGVAR(isEOD), false];
    private _timeToDetermine = 10;
    private _type = if (_isPlayerEOD) then {
        _timeToDetermine = _timeToDetermine - 4 - random 5;
        _target getVariable [QGVAR(type), "MAJOR ERROR - NO TYPE"];
    } else {
        _target getVariable [QGVAR(nonEODType), selectRandom GVAR(allTypes)];
    };
    _target setVariable [QGVAR(nonEODType), _type];
    private _description = format ["I think this bomb is a %1", _type];
    [_timeToDetermine, [_description], {
        _args params ["_description"];
        hint _description;
        _player groupChat _description;
    }, {}, "Checking bomb out"] call ace_common_fnc_progressBar
}, {
    alive _target
}] call ace_interact_menu_fnc_createAction;
private _openDefusalMenuAction = [QGVAR(openDefusalMenu), "Attempt Defusal", "", {
    [_target] call FUNC(openDefusal);
}, {
    private _disarming = _target getVariable [QGVAR(someoneDisarming), false];
    private _hasDefusalKit = [_player, "ACE_DefusalKit"] call ace_common_fnc_hasItem;
    !_disarming && _hasDefusalKit && alive _target
}] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _determineTypeAction] call ace_interact_menu_fnc_addActionToObject;
[_object, 0, ["ACE_MainActions"], _openDefusalMenuAction] call ace_interact_menu_fnc_addActionToObject;
_object setVariable [QGVAR(hasActions), true];
