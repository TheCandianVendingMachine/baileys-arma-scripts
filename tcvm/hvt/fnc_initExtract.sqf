#include "script_component.hpp"

if !(isServer) exitWith {};

params ["_trigger", "_despawnPositionASL"];
_trigger setVariable [QGVAR(despawnPosition), _despawnPositionASL];
_trigger setVariable [QGVAR(controlledHVTs), []];
_trigger setVariable [QGVAR(hvtsGot), 0];

[_trigger, { _this call FUNC(despawn_runner) }] call FUNC(initTrigger);

#ifdef DEBUG_MODE_FULL
_trigger setVariable [QGVAR(debug), true];
#else
_trigger setVariable [QGVAR(debug), false];
#endif
[{
    params ["_args", "_pfh"];
    _args params ["_trigger"];

    if (_trigger getVariable QGVAR(debug)) then {
        [_trigger] call FUNC(debug_despawnWatcher);
    };
}, 0, [_trigger]] call CBA_fnc_addPerFrameHandler;
