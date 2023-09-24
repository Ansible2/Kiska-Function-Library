/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setMaxDecibels

Description:
    Sets the current max decibel range of spectrum device for the local machine.

Parameters:
    0: _max : <NUMBER> - The decibel level

Returns:
    NOTHING

Examples:
    (begin example)
        [-10] call KISKA_fnc_spectrum_setMaxDecibels;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setMaxDecibels";

params [
	["_max",-10,[123]]
];

missionNamespace setVariable ["#EM_SMax", _max];
