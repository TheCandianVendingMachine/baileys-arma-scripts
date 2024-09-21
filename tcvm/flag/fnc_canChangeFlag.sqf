#include "script_component.hpp"
  
params ["_flag", "_unit"];

private _excluded = _flag getVariable [QGVAR(exclude), []];

private _isFaction = (_flag getVariable [QGVAR(currentFaction), objNull]) isEqualTo side _unit;
private _included = (side _unit) in _excluded;

!_isFaction && !_included