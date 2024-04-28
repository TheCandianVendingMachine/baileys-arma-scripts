#include "script_component.hpp"

PREP(createPlane);
PREP(registerParadropAction);
PREP(spawnParadrop);
PREP(spawnAIParadrop);

[QGVAR(spawnParadrop), { _this call FUNC(spawnParadrop); }] call CBA_fnc_addEventHandler;
