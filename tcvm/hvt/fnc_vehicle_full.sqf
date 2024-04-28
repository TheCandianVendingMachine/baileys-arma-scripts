#include "script_component.hpp"
params ["_vehicle"];
private _emptySeats = [_vehicle] call FUNC(vehicle_getOpenSeats);
(count _emptySeats) == 0