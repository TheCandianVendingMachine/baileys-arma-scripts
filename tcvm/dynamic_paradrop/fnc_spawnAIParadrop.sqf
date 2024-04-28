#include "script_component.hpp"

params ["_side", "_units", "_plane", "_ingressModule"];
        
private _planeObject = [_side, _plane, _ingressModule] call FUNC(spawnParadrop);
private _group = [_side, [0, 0, 0], _units, false, "NONE"] call potato_zeusHC_fnc_createGroup;
{
    _x moveInCargo _planeObject;
} forEach units _group;

