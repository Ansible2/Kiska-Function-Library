/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_getMaxFrequency

Description:
    Gets the current max frequency of the spectrum device for the local machine.

Parameters:
    NONE

Returns:
    <NUMBER> - The max viewable frequency (MHz) of the spectrum device

Examples:
    (begin example)
        private _max = call KISKA_fnc_spectrum_getMaxFrequency;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_getMaxFrequency";

missionNamespace getVariable ["#EM_FMax", 125]
