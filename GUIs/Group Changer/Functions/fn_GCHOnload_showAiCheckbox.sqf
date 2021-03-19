/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_showAiCheckbox

Description:
	Adds control event handler to check box and sets its intial state.

Parameters:
	0: _control <CONTROL> - The control for the checkbox

Returns:
	NOTHING

Examples:
    (begin example)
        [_control] call KISKA_fnc_GCHOnLoad_showAiCheckbox;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad_showAiCheckbox";

params ["_control"];

_control ctrlAddEventHandler ["CheckedChanged",{
	params ["_control", "_checked"];

	// convert from number to bool
	_checked = [false,true] select _checked;
	uiNamespace setVariable ["KISKA_GCH_showAI",_checked];

	[true] call KISKA_fnc_GCH_updateCurrentGroupSection;
}];


// set checked or not initially on open
_control cbSetChecked (uiNamespace getVariable ["KISKA_GCH_showAI",true]);