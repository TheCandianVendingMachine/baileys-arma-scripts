# How to use

There are a few functions this script provides. You can

- Teleport units to existing vehicles post-safe-start
- Teleport units to existing vehicles any time
- Teleport units to script-created vehicles post-safe-start
- Teleport units to script-created vehicles any time

## Queueing a set of groups to teleport to an existing vehicle post-safe-start

Put the following in the `init.sqf`

```sqf
if (isServer) then {
    [<VEHICLE VARIABLE NAME>, [<GROUP VARIABLE NAME 1>, <GROUP VARIABLE NAME 2>, ..., <GROUP VARIABLE NAME n>]] call tcvm_dynamic_teleport_fnc_queueTeleport;
};
```

You can add as many queued teleports as you want.

## Queueing a set of groups to teleport to an existing vehicle any time

You can get the queued info by the following:

```sqf
tpInfo = [<VEHICLE VARIABLE NAME>, [<GROUP VARIABLE NAME 1>, <GROUP VARIABLE NAME 2>, ..., <GROUP VARIABLE NAME n>]] call tcvm_dynamic_teleport_fnc_queueTeleport;
```

When you want the teleport to occur, call the following

```sqf
tpInfo call tcvm_dynamic_teleport_fnc_teleport;
```

## Queueing a set of groups to teleport to an script created vehicle post-safe-start

Put the following in the `init.sqf`

```sqf
if (isServer) then {
    [<VEHICLE CREATION SCRIPT>, [<GROUP VARIABLE NAME 1>, <GROUP VARIABLE NAME 2>, ..., <GROUP VARIABLE NAME n>], <PARAMS TO CREATE SCRIPT>] call tcvm_dynamic_teleport_fnc_queueTeleport;
};
```

You can add as many queued teleports as you want.

## Queueing a set of groups to teleport to an existing vehicle any time

You can get the queued info by the following:

```sqf
tpInfo = [<VEHICLE CREATION SCRIPT>, [<GROUP VARIABLE NAME 1>, <GROUP VARIABLE NAME 2>, ..., <GROUP VARIABLE NAME n>], <PARAMS TO CREATE SCRIPT>] call tcvm_dynamic_teleport_fnc_queueTeleport;
```

When you want the teleport to occur, call the following

```sqf
tpInfo call tcvm_dynamic_teleport_fnc_teleport;
```