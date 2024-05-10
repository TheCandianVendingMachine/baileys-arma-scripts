#include "script_component.hpp"

if (isNil "paramsArray") then {
    paramsArray = [];
    diag_log "[TTT] ParamsArray nil";
};

paramsArray params [
    ["_debugMode", false],
    ["_timeLimit", 8],
    ["_traitorCount", 4],
    ["_traitorStartingMoney", 30],
    ["_detectiveCount", 6],
    ["_detectiveStartingMoney", 20],
    ["_gunSpawnCount", 100],
    ["_enableDetectives", true],
    ["_dnaDecayTime", 120]
];
_traitorCount = 1 / _traitorCount;
_detectiveCount = 1 / _detectiveCount;

GVAR(debug) = _debugMode isEqualTo 1;
GVAR(timeLimit) = _timeLimit * 60;
GVAR(traitorCount) = _traitorCount;
GVAR(traitorStartMoney) = _traitorStartingMoney;
GVAR(detectiveCount) = _detectiveCount;
GVAR(detectiveStartMoney) = _detectiveStartingMoney;
GVAR(enableDetectives)  = _enableDetectives isEqualTo 1;
GVAR(gunSpawnCount) = _gunSpawnCount;
GVAR(dnaDecayTime) = _dnaDecayTime;

