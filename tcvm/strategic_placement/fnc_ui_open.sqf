#include "script_component.hpp"

GVAR(handle_clickHandler) = addMissionEventHandler ["MapSingleClick", FUNC(ui_placePoint)];
GVAR(handle_mapHandler) = addMissionEventHandler ["Map", {
    params ["_open"];
    private _map = (findDisplay 12 displayCtrl 51);
    if (_open) then {
        GVAR(points) = [
            [0, 0, 0],
            [0, 0, 0]
        ];
        GVAR(mapPoint) = [0, 0, 0];

        GVAR(fieldWidth) = 75;
        GVAR(maxLength) = 300;
        GVAR(handle_mapDraw) = _map ctrlAddEventHandler ["Draw", FUNC(ui_drawHelper)];
    } else {
        if ([0, 0, 0] isEqualTo (GVAR(points) select 0) || [0, 0, 0] isEqualTo (GVAR(points) select 1)) then {
            // didnt place both points
            hint "Aborted placement";
        } else {
            // tell server to place here when safe-start ends
            [QGVAR(mine_place), [GVAR(points)#0, GVAR(points)#1, GVAR(fieldWidth)]] call CBA_fnc_serverEvent;
            hint "Set minefield location";
        };
        removeMissionEventHandler ["Map", GVAR(handle_mapHandler)];
        removeMissionEventHandler ["MapSingleClick", GVAR(handle_clickHandler)];
        _map ctrlRemoveEventHandler ["Draw", GVAR(handle_mapDraw)];
    };
}];
openMap [true, false];