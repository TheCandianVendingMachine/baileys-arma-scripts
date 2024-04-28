#include "script_component.hpp"

PREP(registerParadropAction);
PREP(spawnParadrop);

[QGVAR(spawnParadrop), { _this call FUNC(spawnParadrop); }] call CBA_fnc_addEventHandler;
