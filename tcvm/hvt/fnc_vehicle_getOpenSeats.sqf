#include "script_component.hpp"
params ["_vehicle"];
private _emptySeats = (fullCrew [_vehicle, "cargo", true]) select {
    _x params ["_unit", "", "_cargoIndex"];
    (isNull _unit) && { !(_cargoIndex in (_vehicle getVariable [QGVAR(assignedSeats), []])) }
};
_emptySeats