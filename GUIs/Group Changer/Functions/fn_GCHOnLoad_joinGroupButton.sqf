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
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCH_joinGroupButton";

params ["_control"];

_control ctrlAddEventHandler ["ButtonClick",{
	private _selectedGroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];

	if !(isNull _selectedGroup) then {
		if !((group player) isEqualTo _selectedGroup) then {
			[player] joinSilent _selectedGroup;
			[true,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
			[] call KISKA_fnc_GCH_updateSideGroupsList;
		};
	} else {
		["The group you are trying to join does not exist"] call KISKA_fnc_errorNotification;
	};

}];


nil
