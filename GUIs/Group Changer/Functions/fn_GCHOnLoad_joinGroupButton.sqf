/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_joinGroupButton

Description:
	The function that fires on the join group button click event.
	The Event is called from KISKA_fnc_GCH_buttonsOnLoad.

Parameters:
	0: _control <CONTROL> - The control of the button

Returns:
	NOTHING

Examples:
    (begin example)
        call KISKA_fnc_GCH_joinGroupButton;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCH_joinGroupButton"
scriptName SCRIPT_NAME;

params ["_control"]

_control ctrlAddEventHandler ["ButtonClick",{
	private _sidesGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_sidesGroupListBox_ctrl";
	private _index = lbCurSel _sidesGroupListBox_ctrl;

	[player] joinSilent _newGroup;

	[true,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
}];