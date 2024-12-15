/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_deleteSignal

Description:
    Deletes a signal with the given id.

Parameters:
    0: _id : <STRING> - The id of the signal to remove
    1: _global : <BOOL> - `true` to broadcast the change to all machines including JIP (default: `true`)

Returns:
	NOTHING

Examples:
    (begin example)
        ["KISKA_spectrumSignal_2_1"] call KISKA_fnc_spectrum_deleteSignal;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_deleteSignal";

params [
	["_id","",[""]],
    ["_global",true,[true]]
];

if (_global AND isMultiplayer) then {
    [
        _id,
        false
    ] remoteExecCall ["KISKA_fnc_spectrum_deleteSignal",-clientOwner];
	remoteExec ["", "JIPid"];
};


private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
_signalMap deleteAt (toLowerANSI _id);


nil
