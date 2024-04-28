#include "script_component.hpp"

params ["_title", "_side", "_units", "_plane", "_ingressModule", "_count"];

private _paradrop = [format [QGVAR(paradrop_%1), _title regexReplace [" ", "_"]], _title, "", {
    params ["", "", "_params"];
    _params params ["_title", "_side", "_units", "_plane", "_ingress", "_count"];
    
    for "_i" from 1 to _count do {
        [{
            [QGVAR(spawnParadrop), _this] call CBA_fnc_serverEvent;
        }, [_side, _units, _plane, _ingress], (_i - 1) * 10] call CBA_fnc_waitAndExecute;
    }
}, {true}, {}, _this] call ace_interact_menu_fnc_createAction;

[["ACE_ZeusActions"], _paradrop] call ace_interact_menu_fnc_addActionToZeus;
