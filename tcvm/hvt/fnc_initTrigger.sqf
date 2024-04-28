#include "script_component.hpp"

params ["_trigger", "_onActivate"];

_trigger setVariable [QGVAR(activateFunc), _onActivate];

_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerStatements [
    QUOTE([ARR_3(this, thisTrigger, thisList)] call FUNC(trigger_condition)),
    QUOTE([ARR_2(thisTrigger, thisList)] call FUNC(trigger_activation)),
    QUOTE([thisTrigger] call FUNC(trigger_deactivation))
];