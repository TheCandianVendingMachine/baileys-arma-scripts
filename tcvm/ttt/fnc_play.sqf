#include "script_component.hpp"

[] call FUNC(init_items);

GVAR(traitorItems) = [
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

GVAR(detectiveItems) = [
    "armour_l",
    "armour_h",
    "radar",
    "binos",
    "dna",
    "health"
];

GVAR(traitorBuyAceInteract) = [QGVAR(traitorBuyMenu), "Buy Item", "", {}, { true }, FUNC(action_buyItem), [GVAR(traitorItems)]] call ace_interact_menu_fnc_createAction;
GVAR(detectiveBuyAceInteract) = [QGVAR(detectiveBuyMenu), "Buy Item", "", {}, { true }, FUNC(action_buyItem), [GVAR(detectiveItems)]] call ace_interact_menu_fnc_createAction;

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
} forEach [GVAR(traitorItems), GVAR(detectiveItems)];

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