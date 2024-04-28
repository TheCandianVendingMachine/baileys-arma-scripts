#include "script_component.hpp"


params ["_trigger"];

private _allVehicles = list _trigger;
_allVehicles = (_allVehicles select {
    [_x] call FUNC(vehicle_isVehicle)
}) select {
    private _validVehicles = _trigger getVariable QGVAR(extractVehicles);
    (_validVehicles isEqualTo []) || { _x in _validVehicles }
};

/*
    State Transitions
        Moving -> Loading:
            Vehicle is stopped AND on ground
        Moving -> Dead:
            Vehicle cannot move anymore
        Loading -> Moving:
            Vehicles is not stopped OR vehicle is not on ground
        Loading -> Full:
            Vehicle's cargo space is full
        Loading -> Dead:
            Vehicle cannot move anymore
        Full -> Moving:
            Vehicle is moving and there is a real open seat
*/
{
    private _state = _x getVariable [QGVAR(extract_state), VEHICLE_STATE_MOVING];
    switch (_state) do {
        case VEHICLE_STATE_MOVING: {
            if ([_x] call FUNC(vehicle_stopped)) then {
                _state = VEHICLE_STATE_LOADING;
            };
            if ([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_DEAD;
            };
        };
        case VEHICLE_STATE_LOADING: {
            if !([_x] call FUNC(vehicle_stopped)) then {
                _state = VEHICLE_STATE_MOVING;
            };
            if ([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_DEAD;
            };
            if ([_x] call FUNC(vehicle_full)) then {
                _state = VEHICLE_STATE_FULL;
            };
        };
        case VEHICLE_STATE_FULL: {
            private _emptySeats = (fullCrew [_x, "cargo", true]) select {
                _x params ["_unit"];
                isNull _unit
            };
            if (count _emptySeats > 0 && { !([_x] call FUNC(vehicle_stopped)) }) then {
                _state = VEHICLE_STATE_MOVING;
            };
            if ([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_DEAD;
            };
        };
        case VEHICLE_STATE_DEAD: {
            _x setVariable [QGVAR(assignedSeats), []];
            if !([_x] call FUNC(vehicle_dead)) then {
                _state = VEHICLE_STATE_LOADING;
            };
        };
    };
    _x setVariable [QGVAR(extract_state), _state];
} forEach _allVehicles;

private _loadingVehicles = [];
private _deadVehicles = [];
{
    private _state = _x getVariable QGVAR(extract_state);
    switch (_state) do {
        case VEHICLE_STATE_MOVING: { };
        case VEHICLE_STATE_LOADING: {
            _loadingVehicles pushBack _x;
        };
        case VEHICLE_STATE_FULL: {};
        case VEHICLE_STATE_DEAD: {
            _deadVehicles pushBack _x;
        };
    };
} forEach _allVehicles;

// Give up alive civilians back to FSM
private _controlledHVTs = _trigger getVariable QGVAR(controlledHVTs);
{
    if (alive _x) then {
        private _passengers = fullCrew [_x, "cargo", false];
        {
            _x params ["_unit"];
            if (alive _unit && { _unit getVariable [QGVAR(state), -1] == HVT_STATE_IN_VEHICLE }) then {
                unassignVehicle _unit;
                moveOut _unit;
                _unit setVariable [QGVAR(state), HVT_STATE_MOVE_TO_POSITION];
                _controlledHVTs pushBack _unit;
            };
        } forEach _passengers;
    };
} forEach _deadVehicles;
_trigger setVariable [QGVAR(controlledHVTs), _controlledHVTs];

[_trigger, _loadingVehicles] call FUNC(extract_stateTick);
[_trigger, _loadingVehicles] call FUNC(extract_agentTick);