#include "script_component.hpp"

#define SPEED_THRESHOLD 1
#define HEIGHT_THRESHOLD 1.5

params ["_vehicle"];

private _speed = vectorMagnitudeSqr velocity _vehicle;
private _height = (getPosATLVisual _vehicle) select 2;

(_speed <= (SPEED_THRESHOLD * SPEED_THRESHOLD)) && (_height < HEIGHT_THRESHOLD)