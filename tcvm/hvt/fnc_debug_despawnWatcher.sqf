#include "script_component.hpp"
params ["_trigger"];
private _controlledHVTs = _trigger getVariable QGVAR(controlledHVTs);
{
    private _p = getPosATLVisual _x;
    private _state = _x getVariable QGVAR(state);
    drawIcon3D ["", [1,1,1,1], _p, 0, 0, 0, HVT_STATE_STRINGS select _state, 1, 0.05, "PuristaMedium"];
    switch (_state) do {
        case HVT_STATE_MOVE_TO_POSITION: {
            private _tPos = ASLToATL (_trigger getVariable QGVAR(despawnPosition));
            private _icon = "\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa";
            drawIcon3D [_icon, [0,0,1,1], _tPos, 1, 1, 0, "", 1, 0.05, "PuristaMedium"];
            drawLine3D [_p, _tPos, [1, 0, 0, 1]];
        };
        default {};
    }
} forEach _controlledHVTs;
private _allVehicles = list _trigger;
_allVehicles = _allVehicles select { [_x] call FUNC(vehicle_isVehicle) };
{
    private _state = _x getVariable QGVAR(extract_state);
    private _p = getPosATLVisual _x;
    drawIcon3D ["\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa", [0,1,0,1], _p, 1, 1, 0, VEHICLE_STATE_STRINGS select _state, 1, 0.05, "PuristaMedium"];
} forEach _allVehicles;
private _zonePos = getPosATLVisual _trigger;
private _hvtsGot = _trigger getVariable QGVAR(hvtsGot);
drawIcon3D ["\A3\ui_f\data\map\markers\nato\respawn_inf_ca.paa", [1,0,1,1], _zonePos, 1, 1, 0, format ["HVTs Retrieved: %1", _hvtsGot], 1, 0.05, "PuristaMedium"];
private _despawnPos = _trigger getVariable QGVAR(despawnPosition);
drawIcon3D ["\A3\ui_f\data\map\markers\nato\respawn_inf_ca.paa", [1,0,0,1], ASLtoAGL _despawnPos, 1, 1, 0, "Despawn Position", 1, 0.05, "PuristaMedium"];