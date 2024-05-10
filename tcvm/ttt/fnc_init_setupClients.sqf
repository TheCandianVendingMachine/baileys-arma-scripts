#include "script_component.hpp"

{
    _x setVariable [QGVAR(player_index), _forEachIndex, true];
} forEach GVAR(allRealPlayers);

for "_i" from 0 to ceil ((count GVAR(allRealPlayers)) * GVAR(traitorCount)) - 1 do {
    while {
        private _playerIndex = floor random count GVAR(allRealPlayers);
        private _uniqueIndex = (GVAR(allRealPlayers) select _playerIndex) getVariable [QGVAR(player_index), -1];
        (GVAR(traitors) pushBackUnique _uniqueIndex) < 0
    } do {};
};

if (GVAR(enableDetectives)) then {
    for "_i" from 0 to ceil((count GVAR(allRealPlayers)) * GVAR(detectiveCount)) - 1 do {
        while {
            private _playerIndex = floor random count GVAR(allRealPlayers);
            private _player = GVAR(allRealPlayers) select _playerIndex;
            if ([_player] call FUNC(isTraitor)) exitWith { false };
            private _uniqueIndex = _player getVariable [QGVAR(player_index), -1];
            (GVAR(detectives) pushBackUnique _uniqueIndex) < 0
        } do {};
    };
};

private _playerList = [];
{
    _playerList pushBack _x;
} forEach GVAR(allRealPlayers);

while { (count _playerList) > 0 } do {
    for "_i" from 0 to ((count _playerList) - 1) do {
        if ((_playerList select _i) getVariable [QGVAR(initialized), false]) then {
            _playerList deleteAt _i;
            _i = _i - 1;
            if (_i < 0) then { _i = 0 };
        };
    };
};

[QGVAR(client_init), [GVAR(traitors), GVAR(traitorGroup), GVAR(detectives), GVAR(detectiveGroup), GVAR(allRealPlayers)]] call CBA_fnc_globalEvent;