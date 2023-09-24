/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_signalExists

Description:
    Checks if a given spectrum signal exists on the local machine.

Parameters:
    0: _id : <STRING> - The id of the signal to check

Returns:
    <BOOL> - `true` if the signal exists on the local machine, `false` if not

Examples:
    (begin example)
        private _signalExists = ["KISKA_spectrumSignal_2_1"] call KISKA_fnc_spectrum_signalExists
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_signalExists";

params [
	["_id","",[""]]
];


private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
(toLowerANSI _id) in _signalMap
