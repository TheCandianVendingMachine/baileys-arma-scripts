#include "script_component.hpp"

params ["_unit", "_item"];
_item params ["", "_title", "_cost", "_onAdd"];

private _currentMoney = _unit getVariable [QGVAR(money), 0];

if ((_currentMoney - _cost) >= 0) then {
    _unit call _onAdd;
    _currentMoney = _currentMoney - _cost;
    _unit setVariable [QGVAR(money), _currentMoney];
    hint format ["You have bought %1. Money Remaining: $%2", _title, _currentMoney];
} else {
    hint format ["Not enough money! You have $%1", _currentMoney];
};