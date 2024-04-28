#include "script_component.hpp"

params ["_detectionEvent", "_thisTrigger", "_thisList"];
_thisList = _thisList select { [_x] call FUNC(vehicle_isVehicle) };

private _hasAgents = count (_thisTrigger getVariable [QGVAR(controlledHVTs), []]) != 0;
_hasAgents || { _detectionEvent && (count _thisList) > 0 }