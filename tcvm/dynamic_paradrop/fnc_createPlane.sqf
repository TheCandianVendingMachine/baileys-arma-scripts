#include "script_component.hpp"
    
params ["_side", "_pilotClassname", "_spawnClassname", "_spawnPos", "_flyInHeight"];

private _plane = createVehicle [_spawnClassname, ASLToATL [_spawnPos select 0, _spawnPos select 1, _flyInHeight], [], 0, "FLY"];
_plane flyInHeightASL [_flyInHeight, _flyInHeight, _flyInHeight];

private _group = createGroup _side;
private _pilot = _group createUnit [_pilotClassname, [0, 0, 0], [], 0, "NONE"];
_pilot moveInDriver _plane;
_pilot disableAI "AUTOCOMBAT";
_pilot disableAI "AUTOTARGET";
_pilot disableAI "TARGET";

_plane