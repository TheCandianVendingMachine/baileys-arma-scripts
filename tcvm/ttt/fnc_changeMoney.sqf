#include "script_component.hpp"

params ["_unit", "_changeInMoney", ["_reason", ""]];
private _currentMoney = _unit getVariable [QGVAR(money), 0];
_unit setVariable [QGVAR(money), _currentMoney + _changeInMoney];

if !(_reason isEqualTo "") then {
    hint _reason;
};