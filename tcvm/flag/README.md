# Flag

Create a flag objective which can be changed

Set a flag object down, assume it has a name `obj`. In the `init.sqf` put
```sqf
private _excludedSides = [];
[obj, _excludedSides] call tcvm_flag_fnc_setObjective;
```

You can put sides in the `_excludedSides` array to disable those sides from being able to change the flag