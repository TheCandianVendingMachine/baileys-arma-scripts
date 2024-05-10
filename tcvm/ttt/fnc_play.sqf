#include "script_component.hpp"

[] call FUNC(init_items);

GVAR(traitor_items) = [
    "c4",
    "silence_pistol",
    "sniper",
    "armour_l",
    "armour_h",
    "radar",
    "suicide",
    //"burn",
    "thermite_grenade"
];

GVAR(detective_items) = [
    "armour_l",
    "armour_h",
    "radar",
    "binos",
    "dna",
    "health"
];

[QGVAR(traitorBuyMenu), "Buy Item", "", {}, { true }, FUNC(action_buyItem), [GVAR(traitorItems)]] call ace_interact_menu_fnc_createAction;
[QGVAR(detectiveBuyMenu), "Buy Item", "", {}, { true }, FUNC(action_buyItem), [GVAR(detectiveItems)]] call ace_interact_menu_fnc_createAction;

{
    private _array = _x;
    {
        _x params ["_itemID"];
        private _index = _forEachIndex;
        {
            _x params ["_id"];
            if (_id isEqualTo _itemID) exitWith { _array set [_index, _x] };
        } forEach GVAR(items);
    } forEach _x;
} forEach [GVAR(traitor_items), GVAR(detective_items)];

[{ [false] call potato_safeStart_fnc_toggleSafeStart }, [], 15] call CBA_fnc_waitAndExecute;
[{
    !potato_safeStart_safeStartEnabled
}, {
    if (hasInterface) then {
        [QGVAR(initClient), FUNC(client_init)] call CBA_fnc_addEventHandler;
    };
    if (isServer) then {
        [] call FUNC(init_server);
    };
}] call CBA_fnc_waitUntilAndExecute;