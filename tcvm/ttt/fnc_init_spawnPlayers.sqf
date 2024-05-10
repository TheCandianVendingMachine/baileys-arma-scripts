#include "script_component.hpp"

params ["_type", "_spawnCenter", "_spawnRadius", "_zoneWidth", "_zoneHeight"];

["spawnAtLocation", [_spawnCenter, _spawnRadius, _type]] call CBA_fnc_globalEvent;

private _radMarker = createMarker [QGVAR(allowed_area), _spawnCenter];
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
