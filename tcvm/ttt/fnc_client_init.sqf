#include "script_component.hpp"

params ["_traitorList", "_traitorGroup", "_detectiveList", "_detectiveGroup", "_allRealPlayers"];

GVAR(traitors) = _traitorList;
GVAR(traitorGroup) = _traitorGroup;
GVAR(detectives) = _detectiveList;
GVAR(detectiveGroup) = _detectiveGroup;
GVAR(allRealPlayers) = _allRealPlayers;

[QGVAR(clientSpawn), FUNC(client_spawn)] call CBA_fnc_addEventHandler;
[QGVAR(changeMoney), FUNC(changeMoney)] call CBA_fnc_addEventHandler;

ACE_PLAYER addEventHandler ["Killed", FUNC(client_onKilled)];

private _detectBody = [
    QGVAR(detectDead), "Investigate Body", "",
    FUNC(body_detect), { params ["_target"]; !([_target] call FUNC(isAlive)) }, {}, [], [0, 0, 0], 100
] call ace_interact_menu_fnc_createAction;

[ACE_PLAYER, 0, ["ACE_MainActions"], _detectBody] remoteExec ["ace_interact_menu_fnc_addActionToObject"];


ACE_PLAYER setVariable [QGVAR(initialized), true, true];

