#include "script_component.hpp"

params ["_plane"];

if !(_plane getVariable [QGVAR(enabled), false]) exitWith { "Static-line is not enabled on this aircraft" };

private _colour = _plane getVariable QGVAR(light);

private _message = "";
switch (true) do {
    case (_colour isEqualTo LIGHT_OFF_STR): {
        _message = format ["Light is %1", LIGHT_OFF_TEXT];
    };
    case (_colour isEqualTo LIGHT_RED_STR): {
        _message = format ["Light is %1. <t color='%2'>HOOKUP</t> and get ready for jump!", LIGHT_RED_TEXT, ACTION_COLOUR];
    };
    case (_colour isEqualTo LIGHT_GREEN_STR): {
        _message = format ["Light is %1. GO! GO! GO!", LIGHT_GREEN_TEXT];
    };
};
_message
