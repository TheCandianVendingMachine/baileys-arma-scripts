#include "script_component.hpp"
params ["_trigger"];
private _controlledHVTs = _trigger getVariable QGVAR(controlledHVTs);
{
    private _p = getPosATLVisual _x;
    private _state = _x getVariable QGVAR(state);
    drawIcon3D ["", [1,1,1,1], _p, 0, 0, 0, HVT_STATE_STRINGS select _state, 1, 0.05, "PuristaMedium"];
    switch (_state) do {
        case HVT_STATE_MOVE_TO_POSITION: {
            private _tPos = ASLToATL (_trigger getVariable QGVAR(waitPosition));
            private _icon = "\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa";
            drawIcon3D [_icon, [0,0,1,1], _tPos, 1, 1, 0, "", 1, 0.05, "PuristaMedium"];
            drawLine3D [_p, _tPos, [1, 0, 0, 1]];
        };
        case HVT_STATE_MOVE_TO_VEHICLE: {
            private _vehicle = _x getVariable QGVAR(vehicle);
            private _vPos = getPosATLVisual _vehicle;
            private _icon = "\A3\Air_F_Beta\Heli_Transport_01\Data\UI\Map_Heli_Transport_01_base_CA.paa";
            drawIcon3D [_icon, [0,0,1,1], _vPos, 1, 1, 0, "", 1, 0.05, "PuristaMedium"];
            drawLine3D [_p, _vPos, [1, 0, 0, 1]];
        };
        default {};
    }
} forEach _controlledHVTs;
private _allVehicles = list _trigger;
_allVehicles = (_allVehicles select {
    [_x] call FUNC(vehicle_isVehicle)
}) select {
    private _validVehicles = _trigger getVariable QGVAR(extractVehicles);
    (_validVehicles isEqualTo []) || { _x in _validVehicles }
};
{
    private _state = _x getVariable QGVAR(extract_state);
    private _p = getPosATLVisual _x;
    drawIcon3D ["\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa", [0,1,0,1], _p, 1, 1, 0, VEHICLE_STATE_STRINGS select _state, 1, 0.05, "PuristaMedium"];
} forEach _allVehicles;
private _zonePos = getPosATLVisual _trigger;
private _hvtsLeft = _trigger getVariable QGVAR(hvtsLeft);
private _triggerStateMachine = _trigger getVariable QGVAR(state_machine);
private _zoneState = _triggerStateMachine getVariable QGVAR(state);
drawIcon3D ["\A3\ui_f\data\map\markers\nato\respawn_inf_ca.paa", [1,0,1,1], _zonePos, 1, 1, 0, format ["HVTs Left: %1 | State: %2", _hvtsLeft, LOAD_STATE_STRINGS select _zoneState], 1, 0.05, "PuristaMedium"];
private _spawnPos = _trigger getVariable QGVAR(spawnPosition);
private _waitPos = _trigger getVariable QGVAR(waitPosition);
drawIcon3D ["\A3\ui_f\data\map\markers\nato\respawn_inf_ca.paa", [1,0,0,1], ASLtoAGL _spawnPos, 1, 1, 0, "Spawn Position", 1, 0.05, "PuristaMedium"];
if (_waitPos isNotEqualTo _spawnPos) then {
    drawIcon3D ["\A3\ui_f\data\map\markers\nato\respawn_inf_ca.paa", [0,0,1,1], ASLtoAGL _waitPos, 1, 1, 0, "Wait Position", 1, 0.05, "PuristaMedium"];
};