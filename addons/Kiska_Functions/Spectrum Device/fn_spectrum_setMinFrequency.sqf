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

if !(call KISKA_fnc_spectrum_isInitialized) then {
    localNamespace setVariable ["KISKA_spectrum_staged_minFreq",_min];
};

missionNamespace setVariable ["#EM_FMin", _min]
