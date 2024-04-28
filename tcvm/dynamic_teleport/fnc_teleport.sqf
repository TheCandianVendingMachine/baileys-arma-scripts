#include "script_component.hpp"
    
params ["_vehicle", "_groups", "_params"];
if ("CODE" == typeName _vehicle) then {
    _vehicle = _params call _vehicle;
};
[_vehicle, _groups] call FUNC(teleportGroup); 
