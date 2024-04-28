# HVT

This script is quite involved. In order to use it, you must define HVT zones and drop-off zones.
The HVTs will not load into a vehicle until it is stopped within the spawn zone. If they start
moving during loading, the HVTs will abort trying to get in and move to a wait position.

## HVT Spawn Zone

An HVT zone is a trigger with at least one position defined within which the HVT's will spawn from.
The trigger must have a variable name, in this example referred to as `Spawn_Trigger`. Likewise, we
will assume an object exists within the zone which will define where the civilians spawn, called
`Spawn_Position`.

In the `init.sqf`, put the following:

```sqf
if (isServer) then {
    [
        Spawn_Trigger,
        getPosASL Spawn_Position,
        <HVT COUNT>
    ] call tcvm_hvt_fnc_initZone;
};
```

If you replace `<HVT COUNT>` with a number representing how many civilians will spawn, you will
have created a basic HVT spawn zone.

### Advanced HVT Spawn Zone

There are three optional variables to the `fnc_initZone` function which tweak how it will work.
These are:

- Specific Extract Vehicles
- Civilian Wait Position
- HVT Spawn Classnames

The script call will look like:
```sqf
    [
        Spawn_Trigger,
        getPosASL Spawn_Position,
        <HVT COUNT>,
        <EXTRACT VEHICLES>,
        getPosASL <CIVILIAN WAIT POSITION>,
        <HVT CLASSNAMES>
    ] call tcvm_hvt_fnc_initZone;
```

The `<EXTRACT VEHICLES>` argument is a list of variables which will be the only vehicles considered
in a zone.

The `<CIVILIAN WAIT POSITION>` argument is an object where the civilians will wait if they abort
trying to get into the extract vehicle

The `<HVT CLASSNAMES>` argument is list of classnames which will be picked from to spawn from the
extract zone when a vehicle is picking them up.


## HVT Extract Zone

An HVT extract zone is a trigger which civilians will be dropped off.  The trigger must have a
variable name, in this example referred to as `Extract_Trigger`. Likewise, we will assume an
object exists within the zone which will define where the civilians spawn, called
`Extract_Position`.
 

In the `init.sqf`, put the following:

```sqf
if (isServer) then {
    [
        Extract_Trigger,
        getPosASL Extract_Position,
    ] call tcvm_hvt_fnc_initExtract;
};
```