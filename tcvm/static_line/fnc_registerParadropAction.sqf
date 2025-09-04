#include "script_component.hpp"

["ace_interact_menu_newControllableObject", {
    params ["_type"]; // string of the object's classname
    if !(_type isKindOf "Air") exitWith {};

    private _checkLightStatus = [QGVAR(checkLightStatus), "Check light", "", {
        params ["_plane"];
        (_plane call FUNC(lightStatus)) call ace_common_fnc_displayTextStructured;
    }, {
        params ["_plane"];
        _plane getVariable [QGVAR(enabled), false]
    }] call ace_interact_menu_fnc_createAction;

    private _hookup = [QGVAR(hookup), "Hook-up", "", {
        params ["_plane", "_player"];
        "Hooked-up" call ace_common_fnc_displayTextStructured;
        [QGVAR(hookUp), [_plane, _player], _plane] call CBA_fnc_localEvent;
    }, {
        params ["_plane", "_player"];
        (_plane getVariable [QGVAR(enabled), false]) && {
            !([_player, _plane] call FUNC(isHookedUp))
        } && {
            !([_player, _plane] call FUNC(isCrew))
        }
    }] call ace_interact_menu_fnc_createAction;

    private _unhook = [QGVAR(unhook), "Unhook", "", {
        params ["_plane", "_player"];
        "Unhooked" call ace_common_fnc_displayTextStructured;
        [QGVAR(unhook), [_plane, _player], _plane] call CBA_fnc_localEvent;
    }, {
        params ["_plane", "_player"];
        (_plane getVariable [QGVAR(enabled), false]) && {
            ([_player, _plane] call FUNC(isHookedUp))
        } && {
            !([_player, _plane] call FUNC(isCrew))
        }
    }] call ace_interact_menu_fnc_createAction;

    private _changeLight = [QGVAR(changeLight), "Change Light", "", {}, {
        params ["_plane", "_player"];
        (_plane getVariable [QGVAR(enabled), false]) && { [_player, _plane] call FUNC(isCrew) }
    }, {
        params ["_plane"];
        private _off = [QGVAR(change_off), LIGHT_OFF_STR, ["", LIGHT_OFF_COLOUR], {
            params ["_plane", "_player"];
            [QGVAR(changeLight), [_plane, LIGHT_OFF_STR], _plane] call CBA_fnc_localEvent;
        }, {
            params ["_plane"];
            (_plane getVariable QGVAR(light)) isNotEqualTo LIGHT_OFF_STR
        }] call ace_interact_menu_fnc_createAction;

        private _standby = [QGVAR(change_ready), LIGHT_RED_STR, ["", LIGHT_RED_COLOUR], {
            params ["_plane", "_player"];
            [QGVAR(changeLight), [_plane, LIGHT_RED_STR], _plane] call CBA_fnc_localEvent;
        }, {
            params ["_plane"];
            (_plane getVariable QGVAR(light)) isNotEqualTo LIGHT_RED_STR
        }] call ace_interact_menu_fnc_createAction;

        private _go = [QGVAR(change_go), LIGHT_GREEN_STR, ["", LIGHT_GREEN_COLOUR], {
            params ["_plane", "_player"];
            [QGVAR(changeLight), [_plane, LIGHT_GREEN_STR], _plane] call CBA_fnc_localEvent;
        }, {
            params ["_plane"];
            (_plane getVariable QGVAR(light)) isEqualTo LIGHT_RED_STR
        }] call ace_interact_menu_fnc_createAction;

        [
            [_off, [], _plane],
            [_standby, [], _plane],
            [_go, [], _plane]
        ]
    }] call ace_interact_menu_fnc_createAction;

    private _parent = QUOTE(COMPONENT);
    private _parentAction = [_parent, "Static-line", ["\cwr3\vehicles\cwr3_para\ui\icon_parachute_ca.paa", ACTION_COLOUR], {}, {
        params ["_plane"];
        _plane getVariable [QGVAR(enabled), false]
    }] call ace_interact_menu_fnc_createAction;

    [_type, 1, ["ACE_SelfActions"], _parentAction, true] call ace_interact_menu_fnc_addActionToClass;
    [_type, 1, ["ACE_SelfActions", _parent], _checkLightStatus, true] call ace_interact_menu_fnc_addActionToClass;
    [_type, 1, ["ACE_SelfActions", _parent], _hookup, true] call ace_interact_menu_fnc_addActionToClass;
    [_type, 1, ["ACE_SelfActions", _parent], _unhook, true] call ace_interact_menu_fnc_addActionToClass;
    [_type, 1, ["ACE_SelfActions", _parent], _changeLight, true] call ace_interact_menu_fnc_addActionToClass;
}] call CBA_fnc_addEventHandler;

