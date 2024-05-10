#include "script_component.hpp"

GVAR(allRealPlayers) = [];

{
    if ((side _x) isEqualTo blufor) then { GVAR(allRealPlayers) pushBack _x };
} forEach allPlayers - entities "HeadlessClient_F";

[] call FUNC(init_setupClients);

private _spawnZone = [] call FUNC(init_pickZone);

private _markerInfo = [_spawnZone] call FUNC(init_readZone);
_markerInfo params ["_type", "_spawnRadius", "_zoneWidth", "_zoneHeight"];

private _zonePos = getMarkerPos _spawnZone;
private _markerDir = markerDir _spawnZone;

[QGVAR(clientSpawn), [_zonePos, _spawnRadius]] call CBA_fnc_globalEvent;
[_zonePos, _zoneWidth, _zoneHeight, _markerDir] call FUNC(init_spawnWeapons);

private _radMarker = createMarker [QGVAR(allowed_area), _zonePos];
switch (_type) do {
    case 0: {
        _radMarker setMarkerShape "ELLIPSE";
        _radMarker setMarkerSize [_zoneWidth, _zoneWidth];
        _zoneHeight = _zoneWidth;
        _spawnRadius = _zoneWidth;
        systemChat "Ellipse";
    };
    case 1: {
        _radMarker setMarkerShape "RECTANGLE";
        _radMarker setMarkerSize [_zoneWidth, _zoneHeight];
        _radMarker setMarkerDir _markerDir;
        systemChat "Rectangle";
    };
};

_radMarker setMarkerBrush "Border";
_radMarker setMarkerColor "ColorBlue";

[{
    [{
        _this call FUNC(game_serverLoop)
    }, 5, _this] call CBA_fnc_addPerFrameHandler;
}, [CBA_missionTime, _zonePos, _zoneWidth, _zoneHeight, _markerDir], 3] call CBA_fnc_waitAndExecute;