#include "script_component.hpp"

params ["_target", "_player", "_params"];

private _deadData = _target getVariable [QGVAR(dna), [objNull, 0, "ERROR: NO NAME", 0, "", "NONE"]];
_deadData params ["_instigator", "_distance", "_name", "_deadTime", "_killedWith", "_affiliation"];

[QGVAR(say), [
    _player,
    format ["I found a dead body, %1 is dead and they were %2!", _name, _affiliation]
]] call CBA_fnc_globalEvent;

[QGVAR(removeAction), [_target, 0, ["ACE_MainActions", "ttt_detectDead"]]] call CBA_fnc_globalEvent;

private _investigateAction = [QGVAR(investigateDead), "Investigate Body", "", {}, { true }, FUNC(body_investigate), _deadData] call ace_interact_menu_fnc_createAction;
[QGVAR(addAction), [_target, 0, ["ACE_MainActions"], _investigateAction]] call CBA_fnc_globalEvent;
