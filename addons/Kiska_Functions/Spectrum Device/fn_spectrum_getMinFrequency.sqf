/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_getMinFrequency

Description:
    Gets the current min frequency of the spectrum device for the local machine.

Parameters:
    NONE

Returns:
    <NUMBER> - The min viewable frequency (MHz) of the spectrum device

Examples:
    (begin example)
        private _min = call KISKA_fnc_spectrum_getMinFrequency;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_getMinFrequency";

missionNamespace getVariable ["#EM_FMin", 100]
