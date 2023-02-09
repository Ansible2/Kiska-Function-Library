/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convoyAdvanced_removeVehicle

Description:
    Removes a given vehicle from the its convoy.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to remove

Returns:
    NOTHING

Examples:
    (begin example)
        [vic] call KISKA_fnc_convoyAdvanced_removeVehicle;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convoyAdvanced_stopVehicle";

params [
    ["_vehicle",objNull,[objNull]]
];


if (isNull _vehicle) exitWith {
    ["_vehicle is null",false] call KISKA_fnc_log;
    nil
};

// ensure recursive vehicle behind knows it needs to move up
// remove killed and deleted eventhandlers

// TODO: get all namespace vars for vehicle from start function