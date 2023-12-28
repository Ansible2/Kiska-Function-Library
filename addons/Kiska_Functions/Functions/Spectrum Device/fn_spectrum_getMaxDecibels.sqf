/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_getMaxDecibels

Description:
    Gets the current max decibel level scale of the spectrum device for the local machine.

Parameters:
    NONE

Returns:
    <NUMBER> - The max viewable decibel level of the spectrum device

Examples:
    (begin example)
        private _max = call KISKA_fnc_spectrum_getMaxDecibels;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_getMaxDecibels";

missionNamespace getVariable ["#EM_SMax", -10]
