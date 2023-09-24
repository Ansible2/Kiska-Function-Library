/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setMinDecibels

Description:
    Sets the current min decibel range of spectrum device for the local machine.

Parameters:
    0: _min : <NUMBER> - The decibel level

Returns:
    NOTHING

Examples:
    (begin example)
        [-60] call KISKA_fnc_spectrum_setMinDecibels;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setMinDecibels";

params [
	["_min",-60,[123]]
];

missionNamespace setVariable ["#EM_SMin", _min];
