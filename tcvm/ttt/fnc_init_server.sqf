#include "script_component.hpp"

GVAR(allRealPlayers) = [];

{
    if ((side _x) isEqualTo blufor) then { GVAR(allRealPlayers) pushBack _x };
} forEach allPlayers - entities "HeadlessClient_F";

[] call FUNC(init_setupClients);

private _spawnZone = [] call FUNC(init_pickZone);

private _markerInfo = [_spawnZone] call FUNC(init_readZone);
_markerInfo params ["_type", "_spawnRadius", "_zoneWidth", "_zoneHeight"];

private _zonePos = getMarkerPos _markerInfo;

[QGVAR(clientSpawn), [_zonePos, _spawnRadius]] call CBA_fnc_globalEvent;
[_zonePos] call FUNC(init_spawnWeapons);

sleep 3;
ttt_timeLeftHints = [false, false, false];
[{
    _this call FUNC(game_serverLoop)
}, 5, [CBA_missionTime, _spawnLocation, _zoneWidth, _zoneHeight, _markerDir]] call CBA_fnc_addPerFrameHandler;