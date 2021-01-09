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
        [_display] call KISKA_fnc_GCHOnLoad_showAiCheckbox;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCHOnLoad_showAiCheckbox"
scriptName SCRIPT_NAME;

params ["_control"];

_control ctrlAddEventHandler ["onCheckedChanged",{
	params ["_control", "_checked"];

	private _currentGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_currentGroupListBox_ctrl"; 
	
	// get bool from _checked number
	_checked = [false,true] select _checked;
	if (_checked) then {
		
	} else {

	};

	// save for the future
	uiNamespace setVariable ["KISKA_GCH_showAI",_checked];
}];


// set checked or not
_control ctrlSetChecked (uiNamespace getVariable ["KISKA_GCH_showAI",false]);