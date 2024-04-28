#include "script_component.hpp"
params ["_origin", "_yield"];

private _calculateBlastWaveArrivalTime = {
    params ["_distanceFromEpicenter", "_explosiveMassTNT", ["_speedOfSound", 343]];
    private _alpha = ((_distanceFromEpicenter^1.4) * (_explosiveMassTNT^-0.2)) / 343;
    private _time = 0.34 * _alpha;
    _time
};

private _mass = [_yield * 1e6, _origin] call potato_miscMedical_fnc_calculateHemisphericalBlastWeight;
private _tntEquivalent = [_mass, "tnt"] call potato_miscMedical_fnc_calculateTNTEquivalent;

private _distanceToBlast =_origin vectorDistance getPosASL ACE_PLAYER;
private _timeUntilBlast = [_distanceToBlast, _tntEquivalent] call _calculateBlastWaveArrivalTime;

[{
    params ["_timeUntilBlast"];
    [floor linearConversion [0, 16, _timeUntilBlast, 4, 1]] spawn BIS_fnc_earthquake;
}, [_timeUntilBlast], _timeUntilBlast] call CBA_fnc_waitAndExecute;

private _intensity = 1 / ((_distanceToBlast * _distanceToBlast) max 1);
// (kilotonnes to joules / atm pressure) ^ 1/5 is rough estimation of fireball diameter
private _totalEnergy = _yield * 4.184e12;
// 50% of total energy is the blast energy
private _fireballRadius = ((0.5 * _totalEnergy / 1.225) ^ (1 / 5)) / 2;

private _fireballArea = 4 * pi * _fireballRadius * _fireballRadius;

private _lightEnergy = 0.35 * _totalEnergy * _intensity;
private _flashBrightness = ln (_lightEnergy / _fireballArea);

private _fireballLifetime = _yield ^ (1 / 4);
private _totalLifetime = 10 * ln (_yield ^ 1.5);

private _lookDirection = eyeDirection ACE_PLAYER;
private _directionToSource = (getPosASLVisual ACE_PLAYER) vectorFromTo _origin;

private _brightness = _flashBrightness * (0 max (_lookDirection vectorDotProduct _directionToSource));

"colorCorrections" ppEffectEnable true;
"colorCorrections" ppEffectAdjust [1 max _brightness min 2, 1 max _flashBrightness, 0, [0.4,0.2,0,0.4], [0.5,0.5,0.5,1],[0.5,0.5,0.5,1]];
"colorCorrections" ppEffectCommit 0;

"colorCorrections" ppEffectAdjust [1, 1 max _flashBrightness, 0, [0.4, 0.2, 0, 0.4], [0.5, 0.5, 0.5, 1], [0.5, 0.5, 0.5, 1]];
"colorCorrections" ppEffectCommit _fireballLifetime;

[{
    params ["_fireballLifetime"];
    "colorCorrections" ppEffectAdjust [1, 1, 0, [0.4, 0.2, 0, 0.4], [0.5, 0.5, 0.5, 1], [0.7, 0.7, 0.7, 1]];
    "colorCorrections" ppEffectCommit _fireballLifetime;

    [{
        params ["_fireballLifetime"];
        "colorCorrections" ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0.299, 0.587, 0.114, 0]];
        "colorCorrections" ppEffectCommit _fireballLifetime;

        [{
            "colorCorrections" ppEffectEnable false;
        }, [], _fireballLifetime] call CBA_fnc_waitAndExecute;

    }, [_fireballLifetime], _fireballLifetime] call CBA_fnc_waitAndExecute;

}, [_fireballLifetime], _fireballLifetime] call CBA_fnc_waitAndExecute;

private _light = "#lightpoint" createVehicleLocal ASLToATL _origin;
_light setLightIntensity (0.35 * _totalEnergy);
_light setLightAmbient [1, 1, 1];
_light setLightColor [1, 1, 1];
_light setLightDayLight true;

[{
    params ["_args", "_handle"];
    _args params ["_light", "_fireballIntensity", "_lifetime", "_startTime"];

    if (CBA_missionTime >= _startTime + _lifetime) exitWith {
        deleteVehicle _light;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    private _timeDecay = (_startTime + _lifetime - CBA_missionTime) / _lifetime;
    private _intensity = _fireballIntensity * (1 - exp (-0.3 * _timeDecay));

    _light setLightIntensity _intensity;

}, 0, [_light, 0.35 * _totalEnergy / _fireballArea, _fireballLifetime, CBA_missionTime]] call CBA_fnc_addPerFrameHandler;

private _allParticleSources = [];
private _fireBallSources = [];
private _smokePillarSources = [];
private _smokeBaseSources = [];
private _slowSmokeBaseSources = [];

private _source = "#particlesource" createVehicleLocal (ASLToATL _origin);
_source setDropInterval 0.1;
_allParticleSources pushBack _source;
_smokePillarSources pushBack _source;

_source = "#particlesource" createVehicleLocal (ASLToATL _origin);
_source setDropInterval 0.3;
_allParticleSources pushBack _source;
_fireBallSources pushBack _source;

_source = "#particlesource" createVehicleLocal (ASLToATL _origin);
_source setDropInterval 0.1;
_allParticleSources pushBack _source;
_fireBallSources pushBack _source;

for "_i" from 0 to 30 do {
    _source = "#particlesource" createVehicleLocal (ASLToATL (_origin getPos [15, _i * 360 / 30]));
    _source setDropInterval 0.1;
    _allParticleSources pushBack _source;
    _smokeBaseSources pushBack _source;
};

for "_i" from 0 to 30 do {
    _source = "#particlesource" createVehicleLocal (ASLToATL (_origin getPos [15, (360 / 60) + _i * 360 / 30]));
    _source setDropInterval 0.1;
    _allParticleSources pushBack _source;
    _slowSmokeBaseSources pushBack _source;
};

[{
    params ["_args", "_handle"];
    _args params ["_start", "_origin", "_fireballRadius", "_fireballLifetime", "_totalLifetime", "_allParticleSources", "_smokePillarSources", "_fireBallSources", "_smokeBaseSources", "_slowSmokeBaseSources"];

    private _timeAlive = CBA_missionTime - _start;

    private _desiredHeight = 500;
    private _lifetime = _totalLifetime - _timeAlive;

    private _velocityNeeded = _desiredHeight / _totalLifetime;
    private _currentRadius = _fireballRadius * linearConversion [0, _fireballLifetime, _timeAlive, 1, 1 / 4, true];

    private _fire = ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 2, 80, 0];
    private _smoke = ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 7, 48, 0];

    if (_timeAlive >= _lifetime) exitWith {
        {
            deleteVehicle _x;
        } forEach _allParticleSources;

        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    if (_timeAlive > _fireballLifetime) then {
        deleteVehicle (_fireBallSources select 0);
        deleteVehicle (_fireBallSources select 1);
    } else {
        (_fireBallSources select 0) setParticleParams [
            _fire, "", "Billboard",
            0, _fireballLifetime,
            [0, 0, 0],
            [0, 0, _velocityNeeded],
            0, 0.3, 1, 0.01, [_fireballRadius],
            [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]],
            [0.7],
            0.1, 1,
            "", "",
            (_fireBallSources select 0),
            random (2 * pi)
        ];

        (_fireBallSources select 1) setParticleParams [
            _smoke, "", "Billboard",
            0, _lifetime,
            [0, 0, 0],
            [0, 0, _velocityNeeded],
            0, 0.3, 1, 0.01, [_fireballRadius],
            [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0.8], [0.1, 0.1, 0.1, 0.8], [0.1, 0.1, 0.1, 0.6], [0.1, 0.1, 0.1, 0]],
            [0.7],
            0.1, 5,
            "", "",
            (_fireBallSources select 1),
            random (2 * pi)
        ];
    };

    (_smokePillarSources select 0) setParticleParams [
        _smoke, "", "Billboard",
        0, _lifetime,
        [0, 0, 0],
        [0, 0, _velocityNeeded],
        0, 0.3, 1, 0.01, [_currentRadius],
        [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0.8], [0.1, 0.1, 0.1, 0.8], [0.1, 0.1, 0.1, 0.6], [0.1, 0.1, 0.1, 0]],
        [1],
        0.1, 1,
        "", "",
        (_smokePillarSources select 0),
        random (2 * pi)
    ];

    private _baseSmokeRadius = _fireballRadius / 4;
    {
        private _awayVector = (getPosASL _x) vectorFromTo _origin;
        _awayVector = vectorNormalized [_awayVector#0, _awayVector#1, 0];

        private _awayVelocity = _awayVector vectorMultiply (5 * _totalLifetime);
        _awayVelocity set [2, -0.05];

        _x setParticleParams [
            _smoke, "", "Billboard",
            0, _lifetime * 1.3,
            [0, 0, _baseSmokeRadius / 4],
            _awayVelocity,
            5, 1.6, 0.02, 0.01, [_baseSmokeRadius, _baseSmokeRadius * 6],
            [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0]],
            [1],
            0.1, 1,
            "", "",
            _x,
            random (2 * pi)
        ];
    } forEach _smokeBaseSources;

    {
        private _awayVector = (getPosASL _x) vectorFromTo _origin;
        _awayVector = vectorNormalized [_awayVector#0, _awayVector#1, 0];

        private _awayVelocity = _awayVector vectorMultiply (1.3 * _totalLifetime);
        _awayVelocity set [2, 0];

        _x setParticleParams [
            _smoke, "", "Billboard",
            0, _fireballLifetime * 1.2,
            [0, 0, _baseSmokeRadius * 1.5],
            _awayVelocity,
            5, 15, 0.01, 0.01, [_baseSmokeRadius],
            [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0.7], [0.1, 0.1, 0.1, 0.5], [0.1, 0.1, 0.1, 0.4], [0.1, 0.1, 0.1, 0.2], [0.1, 0.1, 0.1, 0]],
            [1],
            0.1, 1,
            "", "",
            _x,
            random (2 * pi)
        ];
    } forEach _slowSmokeBaseSources;

}, 1, [CBA_missionTime, _origin, _fireBallRadius, _fireballLifetime, _totalLifetime, _allParticleSources, _smokePillarSources, _fireBallSources, _smokeBaseSources, _slowSmokeBaseSources]] call CBA_fnc_addPerFrameHandler;

