#include "script_component.hpp"
params ["", "_position"];

if ([_position] call FUNC(ui_validPlacement)) then {
    if ([0, 0, 0] isEqualTo (GVAR(points) select 0)) then {
        GVAR(points) set [0, GVAR(mapPoint)];
    } else {
        GVAR(points) set [1, GVAR(mapPoint)];
        openMap false;
    };
}