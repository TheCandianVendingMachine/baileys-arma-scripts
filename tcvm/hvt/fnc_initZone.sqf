#include "script_component.hpp"

if !(isServer) exitWith {};

params ["_trigger", "_spawnPositionASL", "_hvtCount", ["_extractVehicles", []], ["_waitPositionASL", [0, 0, 0]], ["_hvtList", ["C_Man_1"]]];
_trigger setVariable [QGVAR(spawnPosition), _spawnPositionASL];
if (_waitPositionASL isEqualTo [0, 0, 0]) then {
    _waitPositionASL = _spawnPositionASL;
};
_trigger setVariable [QGVAR(waitPosition), _waitPositionASL];
_trigger setVariable [QGVAR(hvtsLeft), _hvtCount];
_trigger setVariable [QGVAR(hvtClassnames), _hvtList];
_trigger setVariable [QGVAR(extractVehicles), _extractVehicles];
_trigger setVariable [QGVAR(controlledHVTs), []];

private _stateMachine = call CBA_fnc_createNamespace;
_stateMachine setVariable [QGVAR(state), LOAD_STATE_WAIT];
_stateMachine setVariable [QGVAR(data), []];

_trigger setVariable [QGVAR(state_machine), _stateMachine];

[_trigger, { _this call FUNC(extract_runner) }] call FUNC(initTrigger);

#ifdef DEBUG_MODE_FULL
_trigger setVariable [QGVAR(debug), true];
#else
_trigger setVariable [QGVAR(debug), false];
#endif
[{
    params ["_args", "_pfh"];
    _args params ["_trigger"];

    if (_trigger getVariable QGVAR(debug)) then {
        [_trigger] call FUNC(debug_zoneWatcher);
    };
}, 0, [_trigger]] call CBA_fnc_addPerFrameHandler;
