#include "script_component.hpp"

PREP(createBriefing);
PREP(addNukeType);
PREP(registerNuke);
PREP(addActions);
PREP(openDefusal);
PREP(cutWire);
PREP(detonationHandler);
PREP(fxHandler);

if (isNil QGVAR(database)) then { GVAR(database) = createHashMap; };
if (isNil QGVAR(allTypes)) then { GVAR(allTypes) = []; };
if (isNil QGVAR(activeNukes)) then { GVAR(activeNukes) = []; };

[QGVAR(disarmed), {
    params ["_object", "_unit"];
    _unit say3D QGVAR(BombDefused);

    private _isExample = _object getVariable [QGVAR(isExample), false];
    if (_isExample) then {
        private _defusalDialog = findDisplay DEFUSAL_IDD;
        if (isNull _defusalDialog) exitWith {};
        ctrlShow [DEFUSAL_EXAMPLE_EXPLOSION_IDD, true];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(kill), {
    params ["_unit", "_reason"];
    [_unit, _reason] call ace_medical_status_fnc_setDead;
}] call CBA_fnc_addEventHandler;

[QGVAR(register), FUNC(registerNuke)] call CBA_fnc_addEventHandler;
[QGVAR(startFX), FUNC(fxHandler)] call CBA_fnc_addEventHandler;
[QGVAR(detonate), {
    // if in an example dialog we want to show that you failed
    params ["_object"];
    private _isExample = _object getVariable [QGVAR(isExample), false];
    if (_isExample) then {
        private _defusalDialog = findDisplay DEFUSAL_IDD;
        if (isNull _defusalDialog) exitWith {};

        hint "You blew up.";
        ctrlShow [DEFUSAL_EXAMPLE_EXPLOSION_IDD, true];
    };
}] call CBA_fnc_addEventHandler;

if (isServer) then {
    [QGVAR(detonate), {
        params ["_object"];
        private _isArmed = _object getVariable [QGVAR(armed), false];
        if !(_isArmed) exitWith {};

        private _isExample = _object getVariable [QGVAR(isExample), false];

        private _isDetonated = (_object getVariable [QGVAR(detonated), false]);
        if !(_isDetonated) then {
            if !(_isExample) then {
                private _yield = (_object getVariable [QGVAR(yield), 1]);
                [getPosASLVisual _object, _yield] call FUNC(detonationHandler);
            };

            _object setVariable [QGVAR(detonated), true, true];
        };
    }] call CBA_fnc_addEventHandler;
};

