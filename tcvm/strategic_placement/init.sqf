#include "script_component.hpp"

PREP(ui_open);
PREP(ui_placePoint);
PREP(ui_drawHelper);
PREP(ui_validPlacement);
PREP(populateStrip);
PREP(mines_populateArea);

GVAR(placementArea) = [
    getMarkerPos "placement_area",
    (getMarkerSize "placement_area") select 0,
    (getMarkerSize "placement_area") select 1,
    markerDir "placement_area",
    true
];

if (isServer) then {
    GVAR(mine_marker) = QGVAR(minefield);
    GVAR(mine_marker_text) = QGVAR(minefield_text);
    GVAR(mine_start) = [0, 0, 0];
    GVAR(mine_end) = [0, 0, 0];
    GVAR(mine_width) = 0;
    [QGVAR(mine_place), {
        params ["_start", "_end", "_width"];
        GVAR(mine_start) = _start;
        GVAR(mine_end) = _end;
        GVAR(mine_width) = _width;

        private _middle = (_start vectorAdd _end) vectorMultiply 0.5;
        private _line = _end vectorDiff _start;
        private _length = vectorMagnitude _line;
        private _rotation = ((_line#0) atan2 (_line#1));

        systemChat str [_rotation, _start, _end];

        if ("" == getMarkerColor GVAR(mine_marker)) then {
            createMarker [GVAR(mine_marker), _middle];
        };
        GVAR(mine_marker) setMarkerPos _middle;
        GVAR(mine_marker) setMarkerShape "RECTANGLE";
        GVAR(mine_marker) setMarkerBrush "DiagGrid";
        GVAR(mine_marker) setMarkerColor "ColorRed";
        GVAR(mine_marker) setMarkerSize [_width / 2, _length / 2];
        GVAR(mine_marker) setMarkerDir _rotation;

        if ("" == getMarkerColor GVAR(mine_marker_text)) then {
            createMarker [GVAR(mine_marker_text), _middle];
        };
        GVAR(mine_marker_text) setMarkerPos _middle;
        GVAR(mine_marker_text) setMarkerShape "ICON";
        GVAR(mine_marker_text) setMarkerText "MINEFIELD";
        GVAR(mine_marker_text) setMarkerType "hd_warning";
    }] call CBA_fnc_addEventHandler;

    ["potato_safeStartOff", {
        if (GVAR(mine_width) != 0) then {
            [GVAR(mine_start), GVAR(mine_end), GVAR(mine_width)] call FUNC(populateStrip);
        };
    }] call CBA_fnc_addEventHandler;
}