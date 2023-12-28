/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playDrivePath

Description:
    Uses setDriveOnPath to move a vehicle. Additionally makes sure the vehicle
     can move before starting (turn engineOn and use doStop).

Parameters:
    0: _vehicle <OBJECT> - The vehicle to use setDriveOnPath command on
    1: _pathArray <ARRAY> - An array of positions in [x,y,z] format or
        [x,y,z,speed-in-meters-per-second] for the vehicle to drive on.
        (see setDriveOnPath documentation)

Returns:
    NOTHING

Examples:
    (begin example)
        [
            _vehicle,
            _pathArray
        ] call KISKA_fnc_playDrivePath;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playDrivePath";

params [
    ["_vehicle",objNull,[objNull]],
    ["_pathArray",[],[[]]]
];

if (isNull _vehicle) exitWith {
    ["_vehicle is null!",true] call KISKA_fnc_log;
    nil
};

private _driver = driver _vehicle;
if (isNull _driver) exitWith {
    ["_vehicle has no driver!",true] call KISKA_fnc_log;
    nil
};


_vehicle engineOn true;
if !(isAgent teamMember _driver) then {
    doStop _driver;
};

// some time (more then one frame) is needed after doStop to execute setDriveOnPath
[
    {
        (_this select 0) setDriveOnPath (_this select 1);
    },
    [_vehicle,_pathArray],
    1
] call CBA_fnc_waitAndExecute;
