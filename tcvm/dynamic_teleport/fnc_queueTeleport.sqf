#include "script_component.hpp"

params ["_vehicle", "_groups", ["_vehicleParams", []]];

private _queueInfo = [_vehicle, _groups, _vehicleParams];
GVAR(queuedTeleports) pushBack _queueInfo;
_queueInfo
