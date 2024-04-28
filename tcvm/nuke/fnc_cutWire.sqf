#include "script_component.hpp"
params ["_object", "_wireIDC"];
ctrlEnable [_wireIDC, false];

private _cutWires = _object getVariable [QGVAR(cutWires), []];

_cutWires pushBack _wireIDC;
_object setVariable [QGVAR(cutWires), _cutWires, true];

private _armed = _object getVariable [QGVAR(armed), true];
private _detonated = _object getVariable [QGVAR(detonated), false];
if (!_armed || _detonated) exitWith {};

private _defuseOrder = _object getVariable [QGVAR(defuseOrder), []];
private _defuseIndex = _object getVariable [QGVAR(defuseIndex), 0];

(_defuseOrder select _defuseIndex) params ["", "", "", "_indexIDC"];
if (_indexIDC != _wireIDC) then {
    [QGVAR(detonate), [_object]] call CBA_fnc_globalEvent;
} else {
    _defuseIndex = _defuseIndex + 1;

    _object setVariable [QGVAR(defuseIndex), _defuseIndex, true];

    if (_defuseIndex >= count _defuseOrder) then {
        _object setVariable [QGVAR(armed), false, true];
        [QGVAR(disarmed), [_object, ACE_PLAYER]] call CBA_fnc_globalEvent;
    }
};

