#include "script_component.hpp"
params ["_map"];
private _mousePosInWorld = _map ctrlMapScreenToWorld getMousePosition;

if ([_mousePosInWorld] call FUNC(ui_validPlacement)) then {
    if ([0, 0, 0] isEqualTo (GVAR(points) select 0)) then {
        _map drawIcon [
            "#(rgb,1,1,1)color(1,1,1,1)",
            [1, 0.1, 0.1, 1],
            _mousePosInWorld vectorAdd [0, 10],
            0,
            0,
            0,
            "Place first minefield point"
        ];
        GVAR(mapPoint) = _mousePosInWorld;
    } else {
        _map drawIcon [
            "#(rgb,1,1,1)color(1,1,1,1)",
            [1, 0.1, 0.1, 1],
            _mousePosInWorld vectorAdd [0, 10],
            0,
            0,
            0,
            "Place second minefield point"
        ];

        private _origin = GVAR(points) select 0;
        private _line = _mousePosInWorld vectorDiff _origin;
        private _length = vectorMagnitude _line;

        if (_length > GVAR(maxLength)) then {
            _line = (vectorNormalized _line) vectorMultiply GVAR(maxLength);
            _length = GVAR(maxLength)
        };

        private _direction = vectorNormalized _line;
        private _rotation = (_line#0) atan2 (_line#1);

        GVAR(mapPoint) = _origin vectorAdd (_direction vectorMultiply _length);

        _map drawRectangle [
            _origin vectorAdd (_direction vectorMultiply (0.5 * _length)),
            GVAR(fieldWidth) / 2,
            _length / 2,
            _rotation,
            [0,0,1,1],
            ""
        ];

        _map drawLine [
            _origin,
            _origin vectorAdd (_direction vectorMultiply _length),
            [1, 1, 1, 1],
            10
        ];

        _map drawIcon [
            "#(rgb,1,1,1)color(1,1,1,1)",
            [0.1, 0.1, 0.1, 1],
            _origin vectorAdd (_direction vectorMultiply (0.5 * _length)),
            0,
            0,
            _rotation,
            format ["%1m", floor _length]
        ];
    };
} else {
    _map drawIcon [
        "#(rgb,1,1,1)color(1,1,1,1)",
        [1, 0, 0, 1],
        _mousePosInWorld vectorAdd [0, 10],
        0,
        0,
        0,
        "Cannot place here!"
    ];
};