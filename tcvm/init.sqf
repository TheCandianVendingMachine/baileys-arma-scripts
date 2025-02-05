private _compile = {
    params ["_init"];
    if (fileExists _init) then {
        [] call compile preprocessFileLineNumbers _init;
    };
};

["tcvm\nuke\init.sqf"] call _compile;
["tcvm\hvt\init.sqf"] call _compile;
["tcvm\front_line\init.sqf"] call _compile;
["tcvm\dynamic_paradrop\init.sqf"] call _compile;
["tcvm\dynamic_teleport\init.sqf"] call _compile;
["tcvm\flag\init.sqf"] call _compile;
["tcvm\strategic_placement\init.sqf"] call _compile;
["tcvm\tcvm\init.sqf"] call _compile;