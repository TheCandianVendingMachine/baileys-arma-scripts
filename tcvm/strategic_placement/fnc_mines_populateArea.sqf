#include "script_component.hpp"
params ["_rotation", "_center", "_width", "_height"];

// create minefield sign
_this call {
    params ["_rotation", "_center", "_width", "_height"];
    _rotation = 90 + _rotation;
    private _direction = [cos _rotation, sin _rotation];

    private _distance = 0.5 * _width + 5;

    private _sign = createVehicle ["Land_Sign_MinesDanger_English_F", _center vectorAdd (_direction vectorMultiply _distance), [], 1, "NONE"];
    _sign setDir (270 - _rotation);
    _sign = createVehicle ["Land_Sign_MinesDanger_English_F", _center vectorAdd (_direction vectorMultiply -_distance), [], 1, "NONE"];
    _sign setDir (90 - _rotation);
};

private _cos = cos _rotation;
private _sin = sin _rotation;

private _density = 1 / (10 * 10); // mines/m^2
private _area = _width * _height;
private _mines = _density * _area;

for "_i" from 0 to _mines do {
    private _x = 0.5 * _height * ((2 * random 1) - 1);
    private _y = 0.5 * _width * ((2 * random 1) - 1);

    private _point = _center vectorAdd [_cos * _x - _sin * _y, _sin * _x + _cos * _y, 0];
    if (
        isOnRoad _point || 
        { surfaceIsWater _point } ||
        { [] isNotEqualTo lineIntersectsObjs [AGLtoASL _point, AGLtoASL _point vectorAdd [0, 0, 3], objNull, objNull, false, 4 + 16] } ||
        { (count (nearestMines [_point, [], 0.3 + random 1, false, true])) > 0 }
    ) then {
        _i = _i - 1;
    } else {
        #ifdef DEBUG_MODE_FULL
        private _marker = createMarker [format["mine%1-%2", _i, floor random 10000], _point];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_triangle";
        #endif

        createMine ["APERSMine", [_point#0, _point#1, 0], [], 0];
    }
};