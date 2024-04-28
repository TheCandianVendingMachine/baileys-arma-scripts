#include "script_component.hpp"

params ["_thisTrigger"];
private _pfh = _thisTrigger getVariable QGVAR(extract_runner);
[_pfh] call CBA_fnc_removePerFrameHandler;
_thisTrigger setVariable [QGVAR(extract_runner), -1];