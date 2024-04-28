#include "script_component.hpp"
params ["_trigger", "_loadingVehicles"];
private _stateMachine = _trigger getVariable QGVAR(state_machine);
private _state = _stateMachine getVariable QGVAR(state);
private _data = _stateMachine getVariable QGVAR(data);
private _controlledHVTs = _trigger getVariable QGVAR(controlledHVTs);
private _hvtsLeft = _trigger getVariable QGVAR(hvtsLeft);
/*
    State Transitions:
        Wait -> Spawn:
            HVTs left > 0 AND Loading Vehicles > 0 AND Loading Vehicles with No Agents Moving To
        Spawn -> Cooldown:
            Civilian spawned
        Cooldown -> Wait:
            Cooldown elapsed
*/
if (_state == LOAD_STATE_COOLDOWN) then {
    _data params ["_cooldownEnterTime"];
    if ((CBA_missionTime - _cooldownEnterTime) >= HVT_SPAWN_COOLDOWN) then {
        _state = LOAD_STATE_WAIT;
    };
};
if (_state == LOAD_STATE_WAIT) then {
    if (_hvtsLeft > 0 && (count _loadingVehicles) > 0) then {
        _state = LOAD_STATE_SPAWN;
    };
};
if (_state == LOAD_STATE_SPAWN) then {
    private _hvtSpawnPos = _trigger getVariable QGVAR(spawnPosition);
    private _hvtClassnames = _trigger getVariable QGVAR(hvtClassnames);
    private _hvtClassname = selectRandom _hvtClassnames;
    private _hvt = createAgent [_hvtClassname, ASLtoATL _hvtSpawnPos, [], 0, "CAN_COLLIDE"];
    _hvt disableAI "FSM";
    _hvt setBehaviour "CARELESS";
    _hvt setVariable [QGVAR(state), HVT_STATE_WAIT];
    _controlledHVTs pushBack _hvt;
    _trigger setVariable [QGVAR(hvtsLeft), _hvtsLeft - 1];
    _state = LOAD_STATE_COOLDOWN;
    _data set [0, CBA_missionTime];
    _stateMachine setVariable [QGVAR(data), _data];
};
_stateMachine setVariable [QGVAR(state), _state];
_trigger setVariable [QGVAR(controlledHVTs), _controlledHVTs];