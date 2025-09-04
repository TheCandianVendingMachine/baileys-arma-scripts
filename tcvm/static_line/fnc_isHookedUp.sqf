#include "script_component.hpp"

params ["_unit", "_vehicle"];

if !(_vehicle getVariable [QGVAR(enabled), false]) exitWith { false };

private _hookedTroops = _vehicle getVariable QGVAR(hookedTroops);
(_hookedTroops find _unit) >= 0
