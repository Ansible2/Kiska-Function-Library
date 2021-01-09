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
#define SCRIPT_NAME "KISKA_fnc_GCHOnLoad_showAiCheckbox"
scriptName SCRIPT_NAME;

params ["_control"];

_control ctrlAddEventHandler ["onCheckedChanged",{
	params ["_control", "_checked"];

	// convert from number to bool
	_checked = [false,true] select _checked;
	[_checked] call KISKA_fnc_GCH_updateCurrentGroupList;

	// save for the future
	uiNamespace setVariable ["KISKA_GCH_showAI",_checked];
}];


// set checked or not initially on open
_control ctrlSetChecked (uiNamespace getVariable ["KISKA_GCH_showAI",false]);