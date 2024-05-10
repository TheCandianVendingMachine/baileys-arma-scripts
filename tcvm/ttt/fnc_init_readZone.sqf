#include "script_component.hpp"

params ["_spawnMarker"];

private _spawnLocation = getMarkerPos _spawnMarker;
private _markerDir = markerDir _spawnMarker;
private _markerText = markerText _spawnMarker;
private _zoneWidth = 0;
private _zoneHeight = 0;
private _spawnRadius = 0;
private _type = 0;
if (_markerText select [0, 1] isEqualTo "[") then {
    private _spawnParameters = parseSimpleArray _markerText;
    _spawnParameters params ["_zoneWidthT", ["_zoneHeightT", 0], ["_spawnRadiusT", 0]];
    if ((_spawnRadiusT isEqualTo 0) && !(_zoneHeightT isEqualTo 0)) then {
        _spawnRadiusT = _zoneWidthT min _zoneHeightT;
    };
    _zoneWidth = _zoneWidthT;
    _zoneHeight = _zoneHeightT;
    _spawnRadius = _spawnRadiusT;
    _type = [0, 1] select ((count _spawnParameters > 1) && !(_zoneHeight isEqualTo 0));
} else {
    _zoneWidth = parseNumber _markerText;
    _spawnRadius = _zoneWidth;
    _type = 0;
};

_spawnRadius = _spawnRadius + 50;
[_type, _spawnRadius, _zoneWidth, _zoneHeight]