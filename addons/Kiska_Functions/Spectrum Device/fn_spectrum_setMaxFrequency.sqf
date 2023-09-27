/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setMaxFrequency

Description:
    Sets the current max frequency of the spectrum device for the local machine.

Parameters:
    0: _max : <NUMBER> - The frequency in MHz

Returns:
    NOTHING

Examples:
    (begin example)
        [125] call KISKA_fnc_spectrum_setMaxFrequency;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setMaxFrequency";

params [
	["_max",100,[123]]
];

if !(call KISKA_fnc_spectrum_isInitialized) then {
    localNamespace setVariable ["KISKA_spectrum_staged_maxFreq",_max];
};

missionNamespace setVariable ["#EM_FMax", _max]
