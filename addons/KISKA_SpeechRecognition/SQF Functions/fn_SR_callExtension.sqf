/* ----------------------------------------------------------------------------
Function: KISKA_fnc_SR_callExtension

Description:
	Calls to KISKA_speechRecognition(_x64).dll extension to run a function within
	 it.

Parameters:
	0: _functionToRun <STRING> - The name of the function to run

Returns:
	<STRING> - Whatever the extension returns

Examples:
    (begin example)
		private _return = ["kiska_ext_sr_startrecording"] call KISKA_fnc_SR_callExtension;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_SR_callExtension";

params [
	["_functionToRun","",[""]]
];


if (_functionToRun isEqualTo "") exitWith {
	["Empty function call provided",true] call KISKA_fnc_log;
	nil
};


private _extensionReturn = "KISKA_speechRecognition" callExtension _functionToRun;


_extensionReturn