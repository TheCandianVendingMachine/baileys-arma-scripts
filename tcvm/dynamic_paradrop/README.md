# Dynamic Paradrop

Allowing a paradrop of either AI or player units during session

## Spawning an AI paradrop mid-mission

You can spawn an AI paradrop through the following:

```sqf
[<SIDE>, <UNIT CLASSNAME LIST>, <PLANE CLASSNAME>, <POTATO INGRESS MODULE VARIABLE NAME>] call tcvm_dynamic_paradrop_fnc_spawnAIParadrop;
```

## Spawning a plane for paradrop mid-mission

You can spawn a plane that will do a paradrop through the following:

```sqf
private _plane = [<SIDE>, <PLANE CLASSNAME>, <POTATO INGRESS MODULE VARIABLE NAME>] call tcvm_dynamic_paradrop_fnc_spawnParadrop;
```

### Using `dynamic_teleport` to teleport units to this plane

```sqf
if (isServer) then {
    [
        tcvm_dynamic_paradrop_fnc_spawnParadrop,
        [<GROUP VARIABLE NAME 1>, <GROUP VARIABLE NAME 2>, ..., <GROUP VARIABLE NAME n>],
        [<SIDE>, <PLANE CLASSNAME>, <POTATO INGRESS MODULE VARIABLE NAME>]
    ] call tcvm_dynamic_teleport_fnc_queueTeleport;
};
```

You can add as many queued teleports to different planes as you want.