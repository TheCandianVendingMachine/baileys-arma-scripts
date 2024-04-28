#include "script_component.hpp"
                
params ["_vehicle", "_groups"];
private _index = 0;
{
    if !(isNil "_x") then {
        {
            if (hasInterface) then {
                _x moveInCargo [_vehicle, _index];
            } else {
                [QGVAR(moveInVehicle), [_vehicle, ["cargo", _index]], _x] call CBA_fnc_targetEvent;
            };
            _index = _index + 1;
        } forEach units _x;
    }
} forEach _groups;
