/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_setLeaderButton

Description:
	The function that fires on the set leader button click event.
	
	The function is called in KISKA_fnc_GCHOnLoad.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        call KISKA_fnc_GCH_setLeaderButton;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCH_setLeaderButton";

params ["_control"];

_control ctrlAddEventHandler ["ButtonClick",{

	private _group = uiNamespace getVariable "KISKA_GCH_selectedGroup";

	if ([_group] call KISKA_fnc_GCH_isAllowedToEdit) then {
		private _currentGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_currentGroupListBox_ctrl";
		private _selectedindex = lbCurSel _currentGroupListBox_ctrl;
		private _unitArrayIndex = _currentGroupListBox_ctrl lbValue _selectedindex;
		
		private _unitArray = uiNamespace getVariable "KISKA_GCH_groupUnitList";
		private _unitToSet = _unitArray select _unitArrayIndex;

		if !(_unitToSet isEqualTo (leader _group)) then {
			if (local _group) then {
				_group selectLeader _unitToSet;
			} else {
				[_group,_unitToSet] remoteExecCall ["KISKA_fnc_GCH_setLeaderRemote",2];
			};
		};
		

		// update leader name indicator
		[false,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
	} else {
		hint "You must be the leader or admin to set a leader";
	};
}];


nil