# Front Line

Put down "empty" markers that will define the front line. Label these with variable names. In the `init.sqf` for the mission, put the following:

Note: There are strings around each marker variable name.
`private _markers = ["<MARKER NAME 1>", "<MARKER NAME 2>", ..., "<MARKER NAME N>"];`

To create the frontline, put the following snippet in:

```sqf
if (isServer) then {
    [_markers] call tcvm_front_line_fnc_createFrontLine;
}
```

There are optional variables you can add to customize the front line; ask Bailey for details
