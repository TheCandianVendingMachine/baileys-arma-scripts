#include "script_component.hpp"

params ["_thisTrigger", "_thisList"];

private _existingPFH = _thisTrigger getVariable [QGVAR(extract_runner), -1];

if (_existingPFH == -1) then {
    private _onActivate = _thisTrigger getVariable QGVAR(activateFunc);
    private _pfh = [{
        params ["_args"];
        _args params ["_trigger", "_onActivate"];
        [_trigger] call _onActivate;
    }, 0.3, [_thisTrigger, _onActivate]] call CBA_fnc_addPerFrameHandler;

    _thisTrigger setVariable [QGVAR(extract_runner), _pfh];
};