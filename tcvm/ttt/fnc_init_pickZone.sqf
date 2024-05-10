#include "script_component.hpp"

private _spawnMarker = selectRandom TTT_PLAYZONES; //_spawnMarker = "test";
{
    if ((getMarkerType _x) isEqualTo "") then {
        systemChat format ["Invalid marker %1", _x];
        diag_log text format ["[TTT] Invalid marker %1", _x];
    };
} forEach _potentialZones;

_spawnMarker