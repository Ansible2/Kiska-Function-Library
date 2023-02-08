/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convoyAdvanced_stopVehicle

Description:
    Used in the process of KISKA's advanced convoy to stop a given vehicle.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to stop

Returns:
    NOTHING

Examples:
    (begin example)
        [vic] call KISKA_fnc_convoyAdvanced_stopVehicle;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convoyAdvanced_stopVehicle";

params [
	["_vehicle",objNull,[objNull]]
];

_vehicle limitSpeed 1;
// Limiting the speed is not enough for some vehicles (armor)
(driver _vehicle) disableAI "path";
