# Nuke

In the root directories' `init.sqf`, you need to add the following:

## Adding Nuke Types

This will create a set of default nuke types with their yield.

```sqf
if (isServer) then {
    ["Mark 11", "A fission gun-type nuke developed by the United States in 1956", 11] call tcvm_nuke_fnc_addNukeType;
    ["XM129", "A man-portable atomic detonation munition developed by the United States", 5] call tcvm_nuke_fnc_addNukeType;
    ["W23", "A nuclear artillery shell developed for the main guns on the Iowa-class battleships", 15] call tcvm_nuke_fnc_addNukeType;
    ["RDS-2", "An early Soviet gun-type atomic bomb developed in 1951", 38] call tcvm_nuke_fnc_addNukeType;
    ["RDS-9", "A Soviet ICBM warhead for the R-5M MRBM", 40] call tcvm_nuke_fnc_addNukeType;
    ["Device #3", "A North Korean developed nuclear bomb. First tested in 2013", 10] call tcvm_nuke_fnc_addNukeType;
    ["Improvised Nuclear Device", "A nuclear bomb of unknown origin. Developed in someone's shed probably", 10] call tcvm_nuke_fnc_addNukeType;
    ["B61-3", "An American gravity dropped nuclear bomb", 5] call tcvm_nuke_fnc_addNukeType;
    ["WE.177", "A British gravity dropped nuclear bomb developed in 1966", 10] call tcvm_nuke_fnc_addNukeType;
};
```

You can add your own nuke types or remove from these as wanted. The format for adding nuke types is:

`[<NAME>, <DESCRIPTION>, <YIELD (KiloTonnes)>] call tcvm_nuke_fnc_addNukeType`

This will add the types to the database of potentials nukes.

## Making someone EOD

You will need to set a variable on the units which you want to be EOD's. This variable is

`<UNIT> setVariable [tcvm_nuke_isEOD, true]`

## Adding EOD briefing to units

To only add the briefing to the EOD units, you can use the following code snippet

```sqf
[{
    if (player getVariable ["tcvm_nuke_isEOD", false]) then {
        call tcvm_nuke_fnc_createBriefing;
    };
}] call CBA_fnc_execNextFrame;
```

## Marking Objectives as Nukes

You can mark an object as a nuke, or as an example. You can do so with this:

```sqf
[<OBJECT VARIABLE NAME>, <SECONDS UNTIL DETONATION>, true] call tcvm_nuke_fnc_registerNuke; // For example objectives
[<OBJECT VARIABLE NAME>, <SECONDS UNTIL DETONATION>, false] call tcvm_nuke_fnc_registerNuke; // For real objectives
```

Example objectives will not blow up after the time limit expires. All time limits are post-safe-start.