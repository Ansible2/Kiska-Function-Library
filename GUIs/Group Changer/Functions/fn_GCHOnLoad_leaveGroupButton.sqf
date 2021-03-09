/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_leaveGroupButton

Description:
	The function that fires on the leave group button click event.
	The Event is added in KISKA_fnc_GCHOnLoad.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        call KISKA_fnc_GCH_leaveGroupButton;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCH_leaveGroupButton"
scriptName SCRIPT_NAME;

params ["_control"];

_control ctrlAddEventHandler ["ButtonClick",{
	private _side = side player;
	private _newGroup = createGroup [_side, false];
	[player] joinSilent _newGroup;
}];


nil