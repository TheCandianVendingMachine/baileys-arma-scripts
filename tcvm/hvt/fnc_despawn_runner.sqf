#include "script_component.hpp"

params ["_trigger"];

private _allVehicles = list _trigger;
_allVehicles = _allVehicles select { [_x] call FUNC(vehicle_isVehicle) };
/*
    State Transitions
        Full/Moving -> Unloading:
            Vehicle is stopped AND on ground
        Full/Moving -> Dead:
            Vehicle cannot move anymore
        Unloading -> Moving:
            Vehicles is not stopped OR vehicle is not on ground
        Unloading -> Dead:
            Vehicle cannot move anymore
*/
{
    private _state = _x getVariable [QGVAR(extract_state), VEHICLE_STATE_MOVING];
    if (_state == VEHICLE_STATE_FULL) then {
        _state = VEHICLE_STATE_MOVING;
    };
    switch (_state) do {
        case VEHICLE_STATE_MOVING: {
            if ([_x] call FUNC(vehicle_stopped)) then {
                _state = VEHICLE_STATE_UNLOADING;
            };
            if ([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_DEAD;
            };
        };
        case VEHICLE_STATE_UNLOADING: {
            if !([_x] call FUNC(vehicle_stopped)) then {
                _state = VEHICLE_STATE_MOVING;
            };
            if ([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_DEAD;
            };
        };
        case VEHICLE_STATE_DEAD: {
            _x setVariable [QGVAR(assignedSeats), []];
            if !([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_UNLOADING;
            };
        };
    };
    _x setVariable [QGVAR(extract_state), _state];
} forEach _allVehicles;

private _unloadingVehicles = [];
{
    private _state = _x getVariable QGVAR(extract_state);
    switch (_state) do {
        case VEHICLE_STATE_UNLOADING: {
            _unloadingVehicles pushBack _x;
        };
        case VEHICLE_STATE_DEAD: {
            _unloadingVehicles pushBack _x;
        };
        default {};
    };
} forEach _allVehicles;

// Move civilians out of aircraft and give up to FSM
private _controlledHVTs = _trigger getVariable QGVAR(controlledHVTs);
private _despawnPos = ASLToATL (_trigger getVariable QGVAR(despawnPosition));
{
    if (alive _x) then {
        private _passengers = fullCrew [_x, "cargo", false];
        {
            _x params ["_unit"];
            if (alive _unit && { _unit getVariable [QGVAR(state), -1] == HVT_STATE_IN_VEHICLE }) then {
                unassignVehicle _unit;
                moveOut _unit;
                _unit setVariable [QGVAR(state), HVT_STATE_MOVE_TO_POSITION];
                _unit moveTo _despawnPos;
                _controlledHVTs pushBack _unit;
            };
        } forEach _passengers;
        _x setVariable [QGVAR(assignedSeats), []];
    };
} forEach _unloadingVehicles;

private _hvtsToDelete = [];
private _hvtsGot = _trigger getVariable QGVAR(hvtsGot);
{
    private _distance = _x distance2D _despawnPos;
    if (_distance <= HVT_WAIT_DISTANCE || moveToCompleted _x || moveToFailed _x) then {
        deleteVehicle _x;
        _hvtsToDelete pushBack _forEachIndex;
        _hvtsGot = _hvtsGot + 1;
    };
} forEach _controlledHVTs;

_hvtsToDelete sort false;
{
    _controlledHVTs deleteAt _x;
} forEach _hvtsToDelete;

_trigger setVariable [QGVAR(controlledHVTs), _controlledHVTs];
_trigger setVariable [QGVAR(hvtsGot), _hvtsGot];
