/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_joinGroupButton

Description:
	The function that fires on the join group button click event.
	The Event is called from KISKA_fnc_GCHOnLoad.

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

params ["_control"];

_control ctrlAddEventHandler ["ButtonClick",{
	private _selectedGroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];

	if !(isNull _selectedGroup) then {
		if !((group player) isEqualTo _selectedGroup) then {
			[player] joinSilent _selectedGroup;
			[true,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
		};
	} else {
		hint "The group you are trying to join does not exist";
	};

}];


nil