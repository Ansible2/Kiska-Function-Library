/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_setGroupIdButton

Description:
	The function that fires on the set group id button click event.
	
	This is called from KISKA_fnc_GCH_buttonsOnLoad.

Parameters:
	0: _control <CONTROL> - The control of the button

Returns:
	NOTHING

Examples:
    (begin example)
        call KISKA_fnc_GCH_setGroupIdButton;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCH_setGroupIdButton"
scriptName SCRIPT_NAME;

params ["_control"]

_control ctrlAddEventHandler ["ButtonClick",{
	private _editBox_ctrl = uiNamespace getVariable "KISKA_GCH_groupIdEdit_ctrl";
	private _newId = ctrlText _editBox_ctrl;

	private _selectedGroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];
	
	if !(isNull _selectedGroup) then {
		// case sensetive check to see if there is a change in the name
		if !(_newId isEqualTo (groupId _selectedGroup)) then {
			
			private _sideGroups = uiNamespace getVariable "KISKA_GCH_sideGroupsArray";
			// check if another group already has the id
			private _alreadyHasName = [
				_sideGroups,
				{(groupId _x) isEqualTo (_thisArgs select 0)},
				[_newId]
			] call KISKA_fnc_findIfBool;

			if !(_alreadyHasName) then {
				_selectedGroup setGroupIdGlobal [_newId];

				// update side group list with new id
				private _index = _sideGroups findIf {
					_x isEqualTo _selectedGroup
				};

				private _sideGroupsList_ctrl = uiNamespace getVariable "KISKA_GCH_sidesGroupListBox_ctrl";
				_sideGroupsList_ctrl lbSetText [_index,_newId];
				
				hint "Group Id Updated";
			} else {
				hint "Another group on your side already has this ID";
			};
		};
	};
}];