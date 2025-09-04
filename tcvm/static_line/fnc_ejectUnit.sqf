#include "script_component.hpp"

params ["_unit", "_plane"];

["potato_paradrop_ejectAndParachuteUnit", [_unit, _plane, "Steerable_Parachute_F", velocity _plane], _unit] call CBA_fnc_targetEvent;

