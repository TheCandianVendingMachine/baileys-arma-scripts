#include "script_component.hpp"

params ["_plane"];

private _altitude = (getPosATL _plane) select 2;
_altitude > 50
