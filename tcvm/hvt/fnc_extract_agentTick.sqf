#include "script_component.hpp"

params ["_trigger", "_loadingVehicles"];

private _controlledHVTs = _trigger getVariable QGVAR(controlledHVTs);
private _hvtsToRemove = [];

/*
    State Transitions:
        Wait -> Move To Vehicle:
            Loading Vehicle exists with no units moving to it
        Wait -> Dead:
            Agent Dead

        Move To Vehicle -> Move To Position:
            Vehicle moving to has started moving or vehicle died
        Move To Vehicle -> Get In Vehicle:
            At load position
        Move To Vehicle -> Dead:
            Agent Dead

        Get In Vehicle -> In Vehicle:
            Assigned time has passed 
        Get In Vehicle -> Move To Position:
            Vehicle moving to has started moving or vehicle died
        Get In Vehicle -> Dead:
            Agent Dead

        Move To Position -> Wait:
            Agent reached the wait position
        Move To Position -> Dead:
            Agent Dead

        In Vehicle -> Dead:
            Agent Dead
*/
{
    private _state = _x getVariable QGVAR(state);
    private _oldState = _state;
    if (1 == damage _x) then {
        _state = HVT_STATE_DEAD;
    } else {
        switch (_state) do {
            case HVT_STATE_WAIT: {
                if (count _loadingVehicles > 0) then {
                    private _vehicleToLoadInto = selectRandom _loadingVehicles;
                    private _openSeats = [_vehicleToLoadInto] call FUNC(vehicle_getOpenSeats);

                    private _seat = _openSeats select 0;
                    private _cargoIndex = _seat select 2;
                    _x setVariable [QGVAR(vehicle), _vehicleToLoadInto];
                    _x setVariable [QGVAR(cargoIndex), _cargoIndex];
                    _x setVariable [QGVAR(walkTowardHelicopter), false];
                    _x setVariable [QGVAR(walkTowardLastTime), 0];

                    [_vehicleToLoadInto, _cargoIndex] call FUNC(vehicle_assignSeat);

                    _state = HVT_STATE_MOVE_TO_VEHICLE;
                };
            };
            case HVT_STATE_MOVE_TO_VEHICLE: {
                private _vehicle = _x getVariable QGVAR(vehicle);

                private _getInSelection = getText (configOf _vehicle >> "memoryPointsGetInCargo");
                private _getInDirSelection = getText (configOf _vehicle >> "memoryPointsGetInCargoDir");

                private _selectionWorldPos = _vehicle modelToWorld (_vehicle selectionPosition _getInSelection);
                private _selectionDirectionPos = _vehicle modelToWorld (_vehicle selectionPosition _getInDirSelection);
                private _walkDirection = _selectionWorldPos vectorFromTo _selectionDirectionPos;

                private _moveToward = _x getVariable QGVAR(walkTowardHelicopter);
                private _lastTime = _x getVariable QGVAR(walkTowardLastTime);
                if (_moveToward) then {
                    if (CBA_missionTime - _lastTime >= HVT_WALK_INTERVAL) then {
                        _x setDestination [_selectionWorldPos, "LEADER DIRECT", true];
                        _x setVariable [QGVAR(walkTowardLastTime), CBA_missionTime];
                    };
                    if ((_x distance2D _selectionWorldPos) <= 1) then {
                        _state = HVT_STATE_GET_IN_VEHICLE;
                        _x setVariable [QGVAR(getInTime), CBA_missionTime];
                    };
                } else {
                    if (CBA_missionTime - _lastTime >= HVT_WALK_INTERVAL) then {
                        _x moveTo _selectionWorldPos;
                        _x setVariable [QGVAR(walkTowardLastTime), CBA_missionTime];
                    };
                    if (moveToCompleted _x || moveToFailed _x) then {
                        _x setVariable [QGVAR(walkTowardHelicopter), true];
                    };
                };
                _x forceSpeed (_x getSpeed "NORMAL");

                if ((_vehicle getVariable QGVAR(extract_state)) in [VEHICLE_STATE_MOVING, VEHICLE_STATE_DEAD]) then {
                    _state = HVT_STATE_MOVE_TO_POSITION;
                };
            };
            case HVT_STATE_GET_IN_VEHICLE: {
                private _lastTime = _x getVariable QGVAR(getInTime);
                if (CBA_missionTime - _lastTime >= HVT_GET_IN_TIME) then {
                    private _vehicle = _x getVariable QGVAR(vehicle);
                    private _cargoIndex = _x getVariable QGVAR(cargoIndex);
                    systemChat str _cargoIndex;
                    _x assignAsCargoIndex [_vehicle, _cargoIndex];
                    _x moveInCargo _vehicle;
                    _state = HVT_STATE_IN_VEHICLE;
                } else {
                    private _vehicle = _x getVariable QGVAR(vehicle);
                    if ((_vehicle getVariable QGVAR(extract_state)) in [VEHICLE_STATE_MOVING, VEHICLE_STATE_DEAD]) then {
                        _state = HVT_STATE_MOVE_TO_POSITION;
                    };
                };
            };
            case HVT_STATE_MOVE_TO_POSITION: {
                private _lastTime = _x getVariable QGVAR(walkTowardLastTime);
                private _waitPos = _trigger getVariable QGVAR(waitPosition);
                if (CBA_missionTime - _lastTime >= HVT_WALK_INTERVAL) then {
                    _x moveTo ASLToATL _waitPos;
                    _x setVariable [QGVAR(walkTowardLastTime), CBA_missionTime];
                };
                private _distance = _x distance2D _waitPos;
                if (_distance <= HVT_WAIT_DISTANCE || moveToCompleted _x || moveToFailed _x) then {
                    _state = HVT_STATE_WAIT;
                    doStop _x;
                };
            };
            case HVT_STATE_IN_VEHICLE: {
                private _vehicle = _x getVariable GVAR(vehicle);
                if ([_vehicle] call FUNC(vehicle_dead)) then {
                    _state = HVT_STATE_DEAD;
                };
            };
            default {};
        };
    };

    if (_oldState != _state) then {
        if (_state == HVT_STATE_MOVE_TO_POSITION) then {
            _x setVariable [QGVAR(walkTowardLastTime), 0];
        };
        if (
            _state == HVT_STATE_DEAD || 
            { _state == HVT_STATE_MOVE_TO_POSITION && _oldState in [HVT_STATE_MOVE_TO_VEHICLE, HVT_STATE_GET_IN_VEHICLE] }
        ) then {
            private _vehicle = _x getVariable QGVAR(vehicle);
            private _cargoIndex = _x getVariable QGVAR(cargoIndex);
            [_vehicle, _cargoIndex] call FUNC(vehicle_unassignSeat);
        };

        if (_state == HVT_STATE_IN_VEHICLE) then {
            _hvtsToRemove pushBack _forEachIndex;
        };
    };
    _x setVariable [QGVAR(state), _state];
} forEach _controlledHVTs;

_hvtsToRemove sort false;
{
    _controlledHVTs deleteAt _x;
} forEach _hvtsToRemove;

_trigger setVariable [QGVAR(controlledHVTs), _controlledHVTs];