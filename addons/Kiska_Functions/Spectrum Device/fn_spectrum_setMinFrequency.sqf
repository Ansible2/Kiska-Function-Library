/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setMinFrequency

Description:
    Sets the current min frequency of the spectrum device for the local machine.

Parameters:
    0: _min : <NUMBER> - The frequency in MHz

Returns:
    NOTHING

Examples:
    (begin example)
        [80] call KISKA_fnc_spectrum_setMinFrequency;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setMinFrequency";

params [
	["_min",80,[123]]
];

missionNamespace setVariable ["#EM_FMin", _min]
