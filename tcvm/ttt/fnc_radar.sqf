#include "script_component.hpp"

params ["_args", "_pfhHandle"];
_args params ["_markers"];
   
 if !([ACE_PLAYER] call FUNC(isAlive)) exitWith {
    [_pfhHandle] call CBA_fnc_removePerFrameHandler;
    
    {
        deleteMarkerLocal (_x select 1);
    } forEach _markers;
};

private _deleteList = [];
{
    _x params ["_unit", "_marker"];
    if ([_unit] call FUNC(isAlive)) then {
        private _unitName = name _unit;
        
        _marker setMarkerShapeLocal "ICON";
        _marker setMarkerTypeLocal "mil_dot";
        _marker setMarkerPosLocal (getPosASL _unit);
        
        private _side = "NONE";
        if ([_unit] call FUNC(isTraitor)) then {
            _marker setMarkerColorLocal "ColorRed";
            _side = "Traitor";
        } else {
            _marker setMarkerColorLocal "ColorBlack";
            _side = "Innocent";
        };
        _marker setMarkerColorLocal "ColorBlack";
        //_marker setMarkerTextLocal format ["%2", _unitName, _side];
    } else {
        _deleteList pushBack _forEachIndex;
        deleteMarkerLocal _marker;
    };
} forEach _markers;

{
    _markers deleteAt _x;
} forEach _deleteList;

_args set [0, _markers];
_this set [0, _args];