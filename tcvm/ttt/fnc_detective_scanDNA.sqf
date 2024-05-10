#include "script_component.hpp"

params ["_target", "_player", "_params"];

_params params ["_instigator", "_deadTime"];
_player groupChat "Attempting to scan for DNA...";

if ((_deadTime - CBA_missionTime + GVAR(dnaDecayTime)) >= 0) then {
    _player groupChat "Found killer, check map";
    private _marker = createMarkerLocal [
        format [QGVAR(killer_%1_%2), name _instigator, str _deadTime],
        getPosASL _killer
    ];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerTypeLocal "mil_dot";
    _marker setMarkerColorLocal "ColorRed";

    [{
        params ["_args", "_pfhHandle"];
        _args params ["_marker", "_killer"];
        if !([ACE_PLAYER] call FUNC(isAlive)) exitWith {
            [_pfhHandle] call CBA_fnc_removePerFrameHandler;
            deleteMarkerLocal _marker;
        };
        _marker setMarkerPosLocal (getPosASL _killer);
    }, 15, [_marker, _instigator]] call CBA_fnc_addPerFrameHandler;
} else {
    _player groupChat "DNA has gone away";
};