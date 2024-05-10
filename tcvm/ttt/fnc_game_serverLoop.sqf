#include "script_component.hpp"

params ["_args", "_handle"];
_args params ["_timeStarted", "_spawnLocation", "_zoneWidth", "_zoneHeight", "_markerDir"];

private _allPlayers = allPlayers - entities "HeadlessClient_F";
private _isTraitorAlive = false;
private _isInnocentAlive = false;
{
    if !([_x] call FUNC(isAlive)) then { continue; };

    if ([_x] call FUNC(isTraitor)) then {
        _isTraitorAlive = true;
    } else {
        _isInnocentAlive = true;
    };
    
    private _distanceFromCenter = [((getPos _x) vectorDiff _spawnLocation), _markerDir] call FUNC(rotatePoint);
    _distanceFromCenter params ["_distX", "_distY"];

    if (abs(_distX) > _zoneWidth || abs(_distY) > _zoneHeight) then {
        [QGVAR(inform), "Turn around now. You are exiting the allowed area. You will be killed if you proceed", _x] call CBA_fnc_targetEvent;
        if (abs(_distX) > _zoneWidth + 50 || abs(_distY) > _zoneHeight + 50) then {
            if !(GVAR(debug)) then {
                _x setDamage 1;
            } else {
                [QGVAR(inform), "You are dead", _x] call CBA_fnc_targetEvent;
            };
        };
    };
} forEach _allPlayers;

if !(GVAR(debug)) then {
    if (_isInnocentAlive && !_isTraitorAlive) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        [{ [QGVAR(alert), "All TRAITORs are dead! INNOCENT win!"] call CBA_fnc_globalEvent; }, [], 5] call CBA_fnc_waitAndExecute;
        [{ [blufor] remoteExecCall ["potato_adminMenu_fnc_endMission", 0]; }, [], 10] call CBA_fnc_waitAndExecute;
    };
    
    if (!_isInnocentAlive && _isTraitorAlive) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        [{ [QGVAR(alert), "All INNOCENT are dead! TRAITORs win!"] call CBA_fnc_globalEvent; }, [], 5] call CBA_fnc_waitAndExecute;
        [{ [opfor] remoteExecCall ["potato_adminMenu_fnc_endMission", 0]; }, [], 10] call CBA_fnc_waitAndExecute;
    };
    
    if (!_isInnocentAlive && !_isTraitorAlive) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        [{ [QGVAR(alert), "No one is alive! NO ONE wins!"] call CBA_fnc_globalEvent; }, [], 5] call CBA_fnc_waitAndExecute;
        [{ [civilian] remoteExecCall ["potato_adminMenu_fnc_endMission", 0]; }, [], 10] call CBA_fnc_waitAndExecute;
    };
};

private _timeLeft = _timeStarted - CBA_missionTime + GVAR(timeLimit);

if (GVAR(timeHints) isNotEqualTo []) then {
    (GVAR(timeHints) select 0) params ["_time", "_hint"];
    if (_timeLeft <= _time) then {
        [QGVAR(inform), _hint] call CBA_fnc_globalEvent;
        GVAR(timeHints) deleteAt 0;
    };
};

if (_timeLeft <= 0) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
    [QGVAR(inform), "Time limit exceeded, INNOCENT win"] call CBA_fnc_globalEvent;
    [{ [blufor] remoteExecCall ["potato_adminMenu_fnc_endMission", 0]; }, [], 5] call CBA_fnc_waitAndExecute;
};