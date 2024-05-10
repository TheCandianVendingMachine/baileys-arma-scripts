#include "script_component.hpp"

params ["_zonePos", "_zoneWidth", "_zoneHeight", "_markerDir"];
_zonePos params ["_xPos", "_yPos"];

private _bestPositions = [];
private _sampleSize = 15;
// 50 random positions to determine the best out of all of them
for "_j" from 1 to GVAR(gunSpawnCount) do {
    private _averageCoord = [0, 0, 0];
    private _randomPoint = [[(random (_zoneWidth * 2) - _zoneWidth), (random (_zoneHeight * 2) - _zoneHeight)], _markerDir] call FUNC(rotatePoint);
    _randomPoint set [0, (_randomPoint select 0) + _xPos];
    _randomPoint set [1, (_randomPoint select 1) + _yPos];
    private _bestPlacedForCoord = selectBestPlaces [_randomPoint, 25, "(1 + trees + houses) * (1 - sea) * (1 - meadow) * (1 - forest)", 1, _sampleSize];
    {
        private _pos = _x select 0;
        _pos pushBack 0.5;
        _averageCoord = _averageCoord vectorAdd _pos;
    } forEach _bestPlacedForCoord;
    _averageCoord = _averageCoord vectorMultiply (1 / _sampleSize);
    
    private _nearRoads = _averageCoord nearRoads 20;
    if !(_nearRoads isEqualTo []) then {
        _averageCoord = getPosATL selectRandom _nearRoads;
    };
    _bestPositions pushBack _averageCoord;
};

{
    private _gwh = createVehicle ["GroundWeaponHolder", [0, 0, 0], [], 0, "NONE"];
    _gwh setPosATL _x;
    
    private _randomWeapon = selectRandomWeighted GVAR(possibleGuns);
    _randomWeapon params ["_weapon", "_ammoArr"];
    _ammoArr params ["_magazine", "_count"];
    
    _gwh addWeaponCargoGlobal [_weapon, 1];
    _gwh addMagazineCargoGlobal [_magazine, ceil random _count];
    
    private _randomGrenade = selectRandomWeighted GVAR(possibleGrenades);
    if !(_randomGrenade isEqualTo "") then {
        _gwh addMagazineCargoGlobal [_randomGrenade, ceil random 2];
    };
    
} forEach _bestPositions;