#include "script_component.hpp"

params ["_position", "_radius"];
_position params ["_xPos", "_yPos"];
        
private _bestPositions = [];
private _sampleSize = 15;
// 50 random positions to determine the best out of all of them
for "_j" from 1 to 50 do {
    private _averageCoord = [0, 0, 0];
    private _bestPlacedForCoord = selectBestPlaces [[_xPos + (random (_radius * 2) - _radius), _yPos + (random (_radius * 2) - _radius)], 25, "(1 + forest + trees + houses) * (1 - sea) * (1 - meadow)", 1, _sampleSize];
    {
        private _pos = _x select 0;
        _pos pushBack 0;
        _averageCoord = _averageCoord vectorAdd _pos;
    } forEach _bestPlacedForCoord;
    _averageCoord = _averageCoord vectorMultiply (1 / _sampleSize);
    _bestPositions pushBack _averageCoord;
};

private _spawn = selectRandom _bestPositions;
        
switch (true) {
    case ([ACE_PLAYER] call ttt_f_isTraitor): {
        [] call FUNC(client_initTraitor);
    };
    case ([ACE_PLAYER] call ttt_f_isDetective): {
        [] call FUNC(client_initDetective);
    };
    default {
        [] call FUNC(client_initInnocent);
    };
};
ACE_PLAYER addItem INNOCENT_RADIO;
ACE_PLAYER setPosATL _spawn;

if (GVAR(detectiveList) isNotEqualTo []) then {
    [{ hint "All of the detectives are listed in your briefing" }, [], 5] call CBA_fnc_waitAndExecute;
    private _detectives = "";
    {
        private _playerName = name (allRealPlayers select _x);
        _detectives = _detectives + _playerName + "<br/>"
    } forEach GVAR(detectiveList);
    ACE_PLAYER createDiarySubject [QGVAR(detectiveList), "DETECTIVE LIST"];
    ACE_PLAYER createDiaryRecord [QGVAR(detectiveList), ["DETECTIVES", _detectives]];
};
