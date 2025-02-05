#include "script_component.hpp"
params ["_start", "_end", "_width"];

_start = [_start#0, _start#1, 0];
_end = [_end#0, _end#1, 0];

private _line = _end vectorDiff _start;
private _length = vectorMagnitude _line;
private _direction = vectorNormalized _line;
private _rotation = (_direction#1) atan2 (_direction#0);

// meters / sign
private _subdivisions = ceil (_length / 15);

private _subLength = _length / _subdivisions;
private _origin = _start vectorAdd (_direction vectorMultiply (0.5 * _length / _subdivisions));
for "_i" from 0 to (_subdivisions - 1) do {
    private _p = _i / _subdivisions;
    private _point = _origin vectorAdd (_direction vectorMultiply (_length * _p));
    [_rotation, _point, _width, _subLength] call FUNC(mines_populateArea);
};