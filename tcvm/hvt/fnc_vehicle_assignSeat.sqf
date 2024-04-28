#include "script_component.hpp"

params ["_vehicle", "_cargoIndex"];

private _assignedSeats = _vehicle getVariable [QGVAR(assignedSeats), []];
_assignedSeats pushBack _cargoIndex;
_vehicle setVariable [QGVAR(assignedSeats), _assignedSeats];
