#include "script_component.hpp"
    
params ["_waypointMarkerNames", ["_markerColour", "ColorRed"], ["_frontlineWidth", 15], ["_markerBrush", "DiagGrid"]];
    
private _lerp = {
    params ["_coordinateA", "_coordinateB", "_value"];
    _coordinateA params["_x0", "_y0", ["_z0", 0]];
    _coordinateB params["_x1", "_y1", ["_z1", 0]];
    
    private _lerpX = linearConversion [0, 1, _value, _x0, _x1];
    private _lerpY = linearConversion [0, 1, _value, _y0, _y1];
    private _lerpZ = linearConversion [0, 1, _value, _z0, _z1];
    
    [_lerpX, _lerpY, _lerpZ];
};

for "_i" from 1 to (count _waypointMarkerNames) do {
    private _waypointA = (_waypointMarkerNames select (_i - 1));
    private _waypointB = (_waypointMarkerNames select _i);
        
    private _aPos = getMarkerPos _waypointA;
    private _bPos = getMarkerPos _waypointB;
    
    private _distanceBetweenWaypoints = _aPos distance2D _bPos;
    private _midPoint = [_aPos, _bPos, 0.5] call _lerp;
    
    private _marker = createMarker[_waypointA + "_visual", _midPoint];
    _marker setMarkerShape "RECTANGLE";
    _marker setMarkerSize [_distanceBetweenWaypoints / 2, _frontlineWidth];
    
    _marker setMarkerBrush _markerBrush;
    _marker setMarkerColor _markerColour;
    
    _marker setMarkerDir (_aPos getDir _bPos) + 90;
    
};