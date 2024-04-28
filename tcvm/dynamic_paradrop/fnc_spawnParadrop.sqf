#include "script_component.hpp"

params ["_side", "_plane", "_ingressModule", ["_launchEvent", QGVAR(launch)]];
        
private _position = getPosASLVisual _ingressModule;
private _flyInHeight = parseNumber (_ingressModule getVariable ["potato_paradrop_flyInHeight", "150"]);
private _dropDelay = parseNumber (_ingressModule getVariable ["potato_paradrop_dropDelay", "0.3"]);
private _infantryParachuteClassname = _ingressModule getVariable ["potato_paradrop_infantryParachuteType", "Steerable_Parachute_F"];
private _cargoParachuteClassname = _ingressModule getVariable ["potato_paradrop_cargoParachuteType", "B_Parachute_02_F"];

private _pilotClassname = "";
if (_side == west) then {
    _pilotClassname = "potato_w_pilot";
};
if (_side == east) then {
    _pilotClassname = "potato_e_pilot";
};
if (_side == resistance) then {
    _pilotClassname = "potato_i_pilot";
};

private _syncObjects = synchronizedObjects _ingressModule;
private _dzs = [];
private _egress = objNull;
private _averageDzPos = [0, 0, 0];
{
    if (_x isKindOf "potato_paradrop_dz") then {
        _dzs pushBack _x;
        _averageDzPos = _averageDzPos vectorAdd (getPosASLVisual _x);
    };
    if (_x isKindOf "potato_paradrop_exit") then {
        _egress = _x;
    };
} forEach _syncObjects;

_averageDzPos = _averageDzPos vectorMultiply (1 / count _dzs);

private _direction = _position vectorFromTo _averageDzPos;

private _planeObject = [civilian, _pilotClassname, _plane, _position vectorAdd (_direction vectorMultiply -500), _flyInHeight] call FUNC(createPlane);
private _speed = vectorMagnitude velocity _planeObject;
_planeObject setVectorDir _direction;
_planeObject setVelocity (_direction vectorMultiply _speed);

private _ingress = [_position, _flyInHeight, _dropDelay, _infantryParachuteClassname, _cargoParachuteClassname] call potato_paradrop_fnc_registerIngress;
{
    [_ingress, getPosASLVisual _x] call potato_paradrop_fnc_registerDz;
} forEach _dzs;
[_ingress, getPosASLVisual _egress] call potato_paradrop_fnc_registerEgress;

[potato_paradrop_fnc_launch, [_ingress, [_planeObject]]] call CBA_fnc_execNextFrame;
[_launchEvent, [_planeObject]] call CBA_fnc_globalEvent;
_planeObject
