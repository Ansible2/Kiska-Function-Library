/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convoyAdvanced_addVehicle

Description:
    Adds a given vehicle to a convoy.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to add

Returns:
    NOTHING

Examples:
    (begin example)
        [vic] call KISKA_fnc_convoyAdvanced_removeVehicle;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convoyAdvanced_removeVehicle";

params [
    ["_vehicle",objNull,[objNull]]
];


if (isNull _vehicle) exitWith {
    ["_vehicle is null",false] call KISKA_fnc_log;
    nil
};

[
    "KISKA_convoyAdvanced_isStopped",
    "KISKA_convoyAdvanced_drivePath",
    "KISKA_convoyAdvanced_debugPathObjects",
    "KISKA_convoyAdvanced_debug",
    "KISKA_convoyAdvanced_hashMap",
    "KISKA_convoyAdvanced_index",
    "KISKA_convoyAdvanced_debugMarkerType_deletedPoint",
    "KISKA_convoyAdvanced_debugMarkerType_queuedPoint",
    "KISKA_convoyAdvanced_queuedPoint"
] apply {
    _vehicle setVariable [_x,nil];
};

// ensure recursive vehicle behind knows it needs to move up
// remove killed and deleted eventhandlers

// TODO: get all namespace vars for vehicle from start function