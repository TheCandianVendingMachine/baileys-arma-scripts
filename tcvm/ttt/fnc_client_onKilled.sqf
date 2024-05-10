#include "script_component.hpp"

params ["_unit", "_killer", "_instigator"];

private _affiliation = "INNOCENT";
private _instigatorFaction = "INNOCENT";

if ([_unit] call FUNC(isTraitor)) then {
    _affiliation = "TRAITOR";
    _instigatorFaction = "TRAITOR";
} else {
    if ([_unit] call FUNC(isDetective)) then {
        _affiliation = "DETECTIVE";
        _instigatorFaction = "DETECTIVE";
    };
};

if !(_instigatorFaction isEqualTo "INNOCENT") then {
    private _moneyGained = 0;
    if ([_instigator] call FUNC(isTraitor)) then {
        if ([_unit] call FUNC(isTraitor)) then {
            _moneyGained = MONEY_LOST_FF;
        } else {
            _moneyGained = MONEY_GAINED_ACCURATE;
        };
    } else {
        if !([_unit] call FUNC(isTraitor)) then {
            _moneyGained = MONEY_LOST_FF;
        } else {
            _moneyGained = MONEY_GAINED_ACCURATE;
        };
    };

    if !(_moneyGained isEqualTo 0) then {
        private _stringArr = if (_moneyGained < 0) then {
            ["LOST", "FELLOW"]
        } else {
            ["GAINED", "ENEMY"]
        };

        [
            QGVAR(changeMoney),
            [_instigator, _moneyGained, format ["You %1 $%2 because you killed a %3 %4", _stringArr select 0, _moneyGained, _stringArr select 1, _affiliation]],
            _instigator
        ] call CBA_fnc_targetEvent;
    };
};

if !(isNull _instigator) then {
    hint format ["You were killed by %1, they were a %2", name _instigator, _instigatorFaction];
} else {
    hint format ["You were killed by no one!", name _instigator, _instigatorFaction];
};

private _killedWithText = [configFile >> "CfgWeapons" >> (currentWeapon _instigator) >> "displayName", "TEXT", "No Weapon"] call CBA_fnc_getConfigEntry;
_unit setVariable [
    QGVAR(dna),
    [
        _instigator,
        _unit distance2d _instigator,
        name _unit,
        CBA_missionTime,
        _killedWithText,
        _affiliation
], true];        
