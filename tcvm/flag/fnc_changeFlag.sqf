#include "script_component.hpp"
    
params ["", "_unit"];

[_unit, "Acts_carFixingWheel", 1] call ace_common_fnc_doAnimation;

[FLAG_CHANGE_TIME, _this, {
    params ["_args"];
    _args params["_flag", "_unit"];

    private _flagType = GVAR(factions) select ((GVAR(factions) find (side _unit)) + 1);
    
    [_flag, _flagType] remoteExec ["setFlagTexture", _flag];

    _flag setVariable [QGVAR(currentFaction), side _unit, true];
    
    [_unit, "", 2] call ace_common_fnc_doAnimation;
}, {
    params ["_args"];
    _args params ["", "_unit"];
    [_unit, "", 2] call ace_common_fnc_doAnimation;
}, "Changing Flag..."] call ace_common_fnc_progressBar;