#include "script_component.hpp"
#define COUNT_OF_UNITS_PER_FRAME 5
#define COUNT_OF_OBJECTS_PER_FRAME 100

#define MAX_BUILDING_RANGE 10000

params ["_origin", "_yield"];
[QGVAR(startFX), _this] call CBA_fnc_globalEvent;

private _calculateBlastWaveArrivalTime = {
    params ["_distanceFromEpicenter", "_explosiveMassTNT", ["_speedOfSound", 343]];
    private _alpha = ((_distanceFromEpicenter^1.4) * (_explosiveMassTNT^-0.2)) / _speedOfSound;
    private _time = 0.34 * _alpha;
    _time
};

private _mass = [_yield * 1e6, _origin] call potato_miscMedical_fnc_calculateHemisphericalBlastWeight;
private _tntEquivalent = [_mass, "tnt"] call potato_miscMedical_fnc_calculateTNTEquivalent;

// binary search to find approximate maximum distance where buildings can take damage
private _minRange = 0;
private _maxRange = MAX_BUILDING_RANGE;

private _damageRange = (_minRange + _maxRange) / 2;
for "_i" from 0 to 1000 do {
    private _scaledDistance = [_damageRange, _tntEquivalent] call potato_miscMedical_fnc_calculateScaledDistance;
    private _pressure = [_scaledDistance] call potato_miscMedical_fnc_calculatePressure;
    private _psi = _pressure / 6895;

    if (_psi < 5) then {
        // bring range in
        _maxRange = _damageRange;
    } else {
        // push range out
        _minRange = _damageRange;
    };

    _damageRange = (_minRange + _maxRange) / 2;
};

private _simulationEndTime = [_damageRange, _tntEquivalent] call _calculateBlastWaveArrivalTime;

private _allUnits = (allUnits - entities "HeadlessClient_f") select { 
    (_origin vectorDistance getPosASL _x) < (1.3 * _damageRange) && alive _x
};

private _allTerrainObjects = nearestTerrainObjects [ASLtoAGL _origin, ["TREE", "BUILDING", "HOUSE", "FENCE", "WALL", "BUNKER", "FUELSTATION", "HOSPITAL", "POWER LINES"], _damageRange, true];
_allTerrainObjects = _allTerrainObjects + ((ASLtoAGL _origin) nearEntities [["LandVehicle", "Air", "Ship"], _damageRange]);

[{
    params ["_args", "_handle"];
    _args params ["_origin", "_tntEquivalent", "_allUnits", "_allTerrainObjects", "_explosionTime", "_calculateBlastWaveArrivalTime", "_damageRange", "_simulationEndTime"];

    #if DEBUG_MODE_DRAW >= 0
        private _distances = [];
        for "_i" from 1 to 16 do {
            _distances pushBack (2 * _damageRange / _i);
        };
        private _blastData = [];
        {
            private _scaledDistance = [_x, _tntEquivalent] call potato_miscMedical_fnc_calculateScaledDistance;
            private _pressure = [_scaledDistance] call potato_miscMedical_fnc_calculatePressure;
            
            private _chanceOfFatality = [_pressure] call potato_miscMedical_fnc_getChanceOfDeath;

            _blastData pushBack [_x, _pressure, _chanceOfFatality];
        } forEach _distances;

        private _maxIconsPerRing = 6;
        {
            _x params ["_distance", "_pressureAtPosition", "_chanceOfFatality"];
            private _iconCount = _maxIconsPerRing;
            if (_distance == 0) then {
                _iconCount = 1;
            };
            
            _chanceOfFatality = 0 max (_chanceOfFatality min 1);
            
            private _colour = vectorLinearConversion [0, 1, _chanceOfFatality, [1, 1, 1], [1, 0, 0]];
            _colour pushBack 1;

            private _timeToBlastWave = [_distance, _tntEquivalent] call _calculateBlastWaveArrivalTime;
            
            for "_i" from 0 to (_iconCount - 1) do {
                private _angle = _i * 2 * pi / _iconCount;
                
                systemChat str [_origin, _distance, _angle];
                private _iconPosition = _origin getPos [_distance, deg _angle];
                
                drawIcon3D [
                    "\a3\ui_f\data\IGUI\Cfg\Cursors\explosive_ca.paa",
                    _colour,
                    _iconPosition,
                    0.2, 0.2, 1,
                    format ["Distance: %1m Pressure: %2Pa Fatality Chance: %3 PsI: %4 Time To Wave: %5", _distance, _pressureAtPosition, _chanceOfFatality, _pressureAtPosition / 6895, _explosionTime + _timeToBlastWave - CBA_missionTime]
                ];
            };
        } forEach _blastData;
    #endif

    #if DEBUG_MODE_DRAW >= 1
        {
            private _distance = (getPosASL _x) vectorDistance _origin;
            private _timeToBlastWave = [_distance, _tntEquivalent] call _calculateBlastWaveArrivalTime;
            private _scaledDistance = [_distance, _tntEquivalent] call potato_miscMedical_fnc_calculateScaledDistance;
            private _pressure = [_scaledDistance] call potato_miscMedical_fnc_calculatePressure;

            private _chanceOfFatality = [_pressure] call potato_miscMedical_fnc_getChanceOfDeath;

            drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,0,0,1], ASLtoAGL getPosASL _x, 0.75, 0.75, 0, format ["Time to Blast: %1 Chance of Fatality: %2", _explosionTime + _timeToBlastWave - CBA_missionTime, _chanceOfFatality], 1, 0.025, "TahomaB"];
        } forEach _allUnits;
    #endif

    #if DEBUG_MODE_DRAW >= 2
        {
            if (_x isKindOf "House" || _x isKindOf "LandVehicle" || _x isKindOf "Air" || _x isKindOf "Ship") then {
                private _distance = (getPosASL _x) vectorDistance _origin;
                private _timeToBlastWave = [_distance, _tntEquivalent] call _calculateBlastWaveArrivalTime;
                private _scaledDistance = [_distance, _tntEquivalent] call potato_miscMedical_fnc_calculateScaledDistance;
                private _pressure = [_scaledDistance] call potato_miscMedical_fnc_calculatePressure;

                private _damage = linearConversion [1, 20, _pressure / 6895, 0.1, 1];

                drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [0,0,1,1], ASLtoAGL getPosASL _x, 0.75, 0.75, 0, format ["Time to Blast: %1 Damage: %2", _explosionTime + _timeToBlastWave - CBA_missionTime, _damage], 1, 0.025, "TahomaB"];
            }
        } forEach _allTerrainObjects;
    #endif

    if (_allUnits isNotEqualTo []) then {
        // process 5 players per frame to determine if they die due to the nuke
        for "_i" from 0 to (COUNT_OF_UNITS_PER_FRAME min count _allUnits) do {
            private _unit = _allUnits select _i;

            private _distance = (getPosASL _unit) vectorDistance _origin;
            private _timeToBlastWave = [_distance, _tntEquivalent] call _calculateBlastWaveArrivalTime;

            if (CBA_missionTime >= _explosionTime + _timeToBlastWave) then {
                private _scaledDistance = [_distance, _tntEquivalent] call potato_miscMedical_fnc_calculateScaledDistance;
                private _pressure = [_scaledDistance] call potato_miscMedical_fnc_calculatePressure;

                private _chanceOfFatality = [_pressure] call potato_miscMedical_fnc_getChanceOfDeath;

                private _kill = (_chanceOfFatality >= random 1);
                if (_kill) then {
                    // kill them
                    [QGVAR(kill), [_unit, "Got Nuke'd"], _unit] call CBA_fnc_targetEvent;
                };

                _allUnits set [_i, objNull];
            };
        };

        _args set [2, _allUnits select { !isNull _x }];
    };

    if (_allTerrainObjects isNotEqualTo []) then {
        private _deleteIndex = 0;

        for "_i" from 0 to (COUNT_OF_OBJECTS_PER_FRAME min count _allTerrainObjects) do {
            private _object = _allTerrainObjects select _deleteIndex;

            private _distance = (getPosASL _object) vectorDistance _origin;
            private _timeToBlastWave = [_distance, _tntEquivalent] call _calculateBlastWaveArrivalTime;

            if (CBA_missionTime >= _explosionTime + _timeToBlastWave) then {
                private _scaledDistance = [_distance, _tntEquivalent] call potato_miscMedical_fnc_calculateScaledDistance;
                private _pressure = [_scaledDistance] call potato_miscMedical_fnc_calculatePressure;

                private _damage = linearConversion [1, 20, _pressure / 6895, 0.1, 1];
                _object setDamage [(damage _object) max _damage, false];

                _allTerrainObjects deleteAt _deleteIndex;
            } else {
                _deleteIndex = _deleteIndex + 1;
            }
        };

        _args set [3, _allTerrainObjects];
    };

    if ((_allTerrainObjects isEqualTo []) && { (_allUnits isEqualTo []) }) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

}, 0, [_origin, _tntEquivalent, _allUnits, _allTerrainObjects, CBA_missionTime, _calculateBlastWaveArrivalTime, _damageRange, _simulationEndTime]] call CBA_fnc_addPerFrameHandler;
