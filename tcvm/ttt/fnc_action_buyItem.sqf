#include "script_component.hpp"

// Add all items to child menu
params ["_target", "_player", "_params"];
_params params ["_items"];

private _playerMoney = _player getVariable [QGVAR(money), 0];
private _actions = [];
{
    _x params ["", "_title", "_cost", "", ["_condition", { true }]];
    if ((_player call _condition) && (_playerMoney - _cost) >= 0) then {
        private _action = [
            format [QGVAR(buy_%1), _title], format ["Buy %1 ($%2)", _title, _cost], "", {
                params ["", "_player", "_params"];
                [_player, _params] call FUNC(buyItem);
            },
            { true },
            {},
            _x
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target]; // New action, it's children, and the action's target
    };
} forEach _items;

_actions