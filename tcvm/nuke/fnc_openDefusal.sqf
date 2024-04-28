#include "script_component.hpp"
params ["_object"];
if !(createDialog QGVAR(defusal)) exitWith {};
_object setVariable [QGVAR(someoneDisarming), true, true];
private _defusalDialog = findDisplay DEFUSAL_IDD;
_defusalDialog setVariable [QGVAR(object), _object];
_defusalDialog displayAddEventHandler ["Unload", {
    params ["_display", "_exitCode"];
    private _object = _display getVariable [QGVAR(object), objNull];
    _object setVariable [QGVAR(someoneDisarming), false, true];
}];
private _width = ((WIRE_WIDTH + WIRE_GAP) * count ALL_COLOURS) + 2 * WIRE_BORDER;
private _height = WIRE_HEIGHT + 2 * WIRE_BORDER;
private _ctrlBackground = _defusalDialog ctrlCreate ["RscBackgroundGUI", -1];
_ctrlBackground ctrlSetPosition [0, 0, _width, _height]; 
_ctrlBackground ctrlCommit 0;
private _menuCancel = _defusalDialog ctrlCreate ["RscButtonMenuCancel",-1]; 
_menuCancel ctrlSetText "Close";
_menuCancel ctrlSetPosition [_width - 0.12, _height, 0.12, 0.08]; 
_menuCancel buttonSetAction "closeDialog 2;"; 
_menuCancel ctrlCommit 0;
private _isExample = _object getVariable [QGVAR(isExample), false];
if (_isExample) then {
    private _resetWidth = 0.6;
    private _resetBombButton = _defusalDialog ctrlCreate ["RscButtonMenuCancel", DEFUSAL_EXAMPLE_EXPLOSION_IDD]; 
    _resetBombButton ctrlSetText "Click to reset bomb (Example Only)";
    _resetBombButton ctrlSetPosition [(0.5 * (_width - _resetWidth)), -0.08, _resetWidth, 0.08];
    _resetBombButton buttonSetAction format ["closeDialog 2; ['%1', [%2, %3, %4]] call CBA_fnc_globalEvent; hint 'Example Bomb Reset'", QGVAR(register), _object, 0, true]; 
    _resetBombButton ctrlCommit 0;
    ctrlShow [DEFUSAL_EXAMPLE_EXPLOSION_IDD, (_object getVariable [QGVAR(detonated), false]) || !(_object getVariable [QGVAR(armed), false])];
};
private _wireOrder = _object getVariable [QGVAR(wireOrder), []];
if (_wireOrder isEqualTo []) then {
    _wireOrder = ALL_COLOURS call BIS_fnc_arrayShuffle;
    _object setVariable [QGVAR(wireOrder), _wireOrder, true];
};
private _cutWires = _object getVariable [QGVAR(cutWires), []];
{
    _x params ["_rgbArray", "", "_colour", "_idc"];
    private _rgba = _rgbArray + [255];
    private _activeRGBA = _rgbArray + [255];
    _rgba = _rgba apply {
        _x / 255
    };
    _activeRGBA = _activeRGBA apply {
        _x / 255
    };
    private _wire = _defusalDialog ctrlCreate ["RscButton", _idc];
    _wire ctrlSetText _colour; 
    _wire ctrlSetPosition [WIRE_BORDER + (WIRE_GAP + WIRE_WIDTH) * _forEachIndex, WIRE_BORDER, WIRE_WIDTH, WIRE_HEIGHT]; 
    _wire ctrlSetForegroundColor _rgba;
    _wire ctrlSetBackgroundColor _rgba;
    _wire ctrlSetActiveColor _activeRGBA;
    _wire ctrlSetDisabledColor [0, 0, 0, 0];
    _wire buttonSetAction format ["%1 call %2", [_object, _idc], QFUNC(cutWire)];
    _wire ctrlCommit 0;
    if (_idc in _cutWires) then {
        ctrlEnable [_idc, false];
    };
} forEach _wireOrder;
