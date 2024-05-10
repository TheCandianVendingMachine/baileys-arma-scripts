#include "script_component.hpp"

params ["_target", "_player", "_params"];
_params params ["_name", "_affiliation", "_killedWith", "_deadTime"];

private _timeRemaining = (_deadTime - CBA_missionTime + GVAR(dnaDecayTime)) max 0;
_player groupChat format ["%1 was %2, they were killed with %3 about %4 minutes ago. DNA is gone in %5 minutes",
    _name,
    _affiliation,
    _killedWith,
    PRETTY_TIME(CBA_missionTime - _deadTime),
    PRETTY_TIME(_timeRemaining)
];
