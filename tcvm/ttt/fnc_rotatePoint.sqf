#include "script_component.hpp"

params ["_pos", "_deg"];

private _cos = cos _deg;
private _sin = sin _deg;
    
[
    ((_pos select 0) * _cos) + ((_pos select 1) * -_sin),
    ((_pos select 0) * _sin) + ((_pos select 1) *  _cos)
];