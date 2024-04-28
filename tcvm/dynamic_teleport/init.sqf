#include "script_component.hpp"

PREP(onSafeStartOff);
PREP(queueTeleport);
PREP(teleport);
PREP(teleportGroup);

GVAR(queuedTeleports) = [];

[QGVAR(moveInVehicle), {
    params ["_vehicle", "_info"];
    _info params ["_type", "_data"];
    _type = toLower _type;
    switch (true) do {
        case (_type == "cargo"): {
            player moveInCargo [_vehicle, _data];
        };
        case (_type == "driver"): {
            player moveInDriver _vehicle;
        };
        case (_type == "commander"): {
            player moveInCommander _vehicle;
        };
        case (_type == "gunner"): {
            player moveInGunner _vehicle;
        };
        case (_type == "turret"): {
            player moveInTurret [_vehicle, _data];
        };
        default {
            player moveInAny _vehicle;
        };
    };
}] call CBA_fnc_addEventHandler;

["potato_safeStartOff", {
    call FUNC(onSafeStartOff);
}] call CBA_fnc_addEventHandler;