/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_getMinDecibels

Description:
    Gets the current min decibel level scale of the spectrum device for the local machine.

Parameters:
    NONE

Returns:
    <NUMBER> - The min viewable decibel level of the spectrum device

Examples:
    (begin example)
        private _min = call KISKA_fnc_spectrum_getMinDecibels;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_getMinDecibels";

missionNamespace getVariable ["#EM_SMin", -60]
