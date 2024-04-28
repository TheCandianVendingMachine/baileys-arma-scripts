#include "script_component.hpp"
params ["_type", "_description", "_yield"];
private _allColours = ALL_COLOURS;
private _defuseOrder = [];
for "_i" from 1 to DEFUSE_SUCCESS_COUNT do {
    private _randomColour = floor random count _allColours;
    private _colour = _allColours select _randomColour;
    _allColours deleteAt _randomColour;
    _defuseOrder pushBack _colour;
};
GVAR(database) insert [[_type, [_description, _yield, _defuseOrder]]];
GVAR(allTypes) pushBack _type;
publicVariable QGVAR(database);
publicVariable QGVAR(allTypes);
