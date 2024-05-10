#include "script_component.hpp"

PREP(action_buyItem);
PREP(action_detectiveBody);
PREP(action_traitorBody);
PREP(body_detect);
PREP(body_investigate);
PREP(body_timeDead);
PREP(buyItem);
PREP(changeMoney);
PREP(client_init);
PREP(client_initDetective);
PREP(client_initInnocent);
PREP(client_initTraitor);
PREP(client_onKilled);
PREP(client_spawn);
PREP(detective_scanDNA);
PREP(game_serverLoop);
PREP(init_items);
PREP(init_param);
PREP(init_pickZone);
PREP(init_readZone);
PREP(init_server);
PREP(init_setupClients);
PREP(init_spawnPlayers);
PREP(init_spawnWeapons);
PREP(isAlive);
PREP(isDetective);
PREP(isTraitor);
PREP(item_buy);
PREP(play);
PREP(radar);
PREP(rotatePoint);

GVAR(traitors) = [];
GVAR(traitorGroup) = createGroup west;
GVAR(detectives) = [];
GVAR(detectiveGroup) = createGroup west;

GVAR(traitorStartMoney) = 0;
GVAR(detectiveStartMoney) = 0;

GVAR(traitorItems) = [];
GVAR(detectiveItems) = [];

GVAR(possibleGuns) = [
    // [gun, [magazine, maximum count]], probability
    ["CUP_arifle_M4A1", ["30Rnd_556x45_Stanag_Tracer_Red", 2]], 1 / 10,
    ["CUP_hgun_MicroUzi", ["CUP_30Rnd_9x19_UZI", 2]],           1 / 3,
    ["CUP_sgun_M1014", ["CUP_8Rnd_B_Beneli_74Pellets", 2]],     1 / 5,
    ["CUP_hgun_Glock17", ["CUP_17Rnd_9x19_glock17", 3]],        1 / 6,
    ["CUP_hgun_TaurusTracker455", ["CUP_6Rnd_45ACP_M", 4]],     1 / 10,
    ["hgun_ACPC2_F", ["9Rnd_45ACP_Mag", 2]],                    1 / 6,
    ["CUP_srifle_LeeEnfield", ["CUP_10x_303_M", 2]],            1 / 4
];
GVAR(possibleGrenades) = [
    // grenade, probability
    "",                 1 / 2,
    "ACE_M14",          1 / 8,
    "HandGrenade",      1 / 10,
    "ACE_M84",          1 / 5,
    "potato_potato",    1 / 5
];

GVAR(timeHints) = [
    [240, "Four minutes remain."],
    [120, "Two minutes remain."],
    [60, "One minute is all that is left!"]
];

[QGVAR(inform), {
    hintSilent _this;
}] call CBA_fnc_addEventHandler;

[QGVAR(alert), {
    hintSilent _this;
}] call CBA_fnc_addEventHandler;

[QGVAR(play), {
    params ["_source", "_audio"];
    _source say3D _audio;
}] call CBA_fnc_addEventHandler;

[QGVAR(say), {
    params ["_person", "_text"];
    _person globalChat _text;
}] call CBA_fnc_addEventHandler;

[QGVAR(addAction), {
    _this call ace_interact_menu_fnc_createAction
}] call CBA_fnc_addEventHandler;

[QGVAR(removeAction), {
    _this call ace_interact_menu_fnc_removeActionFromObject;
}] call CBA_fnc_addEventHandler;

[] call FUNC(init_param);