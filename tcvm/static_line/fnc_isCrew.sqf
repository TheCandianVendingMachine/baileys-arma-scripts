#include "script_component.hpp"

params ["_unit", "_vehicle"];

private _isCrew = false;
{
    _x params ["_member", "_role"];
    if (_member isEqualTo _unit && _role isNotEqualTo "cargo") exitWith { _isCrew = true; };
} forEach fullCrew [_vehicle, "", false];
_isCrew
