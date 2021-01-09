/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_sideGroupList

Description:
	Adds eventhandler to the listbox.

Parameters:
	0: _control <CONTROL> - The control for the list box

Returns:
	NOTHING

Examples:
    (begin example)
        [_control] call KISKA_fnc_GCHOnLoad_sideGroupList;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCHOnLoad_sideGroupList"
scriptName SCRIPT_NAME;

params ["_control"];

private _playerSide = side player;
private _allGroupsCached = allGroups;
private _sideGroups = _allGroupsCached select {(side _x) isEqualTo _playerSide};
private _sideGroupIds = [];
private _fn_popSideGroupIds = {
	_sideGroups apply {
		_sideGroupIds pushBack (groupId _x);
	};
};
call _fn_popSideGroupIds;

uiNamespace setVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];


private _fn_updateSideGroupList = {
	lbClear _control;
	// update id list
	call _fn_popSideGroupIds;

	// add to listbox
	private "_index";
	{
		_index = _control lbAdd _x;
		// saving the index as a value so that it can be referenced against the _sideGroups array
		_control lbSetValue [_index,_forEachIndex];
	} forEach _sideGroupIds;

	// sort list alphabetically
	lbSort _control;
};




// add event handler
_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	
	// get selected group
	private _sideGroups = uiNamespace getVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];
	private _sideGroupsIndex = _control lbValue _selectedIndex;
	private _selectedGroup = _sideGroups select _sideGroupsIndex;
	uiNamespace setVariable ["KISKA_GCH_selectedGroup",_selectedGroup];

	// units list
	private _groupUnits = units _selectedGroup;
	if !(uiNamespace getVariable "KISKA_GCH_showAI") then {
		_groupUnits = _groupUnits select (isPlayer _x);
	};
	private _currentGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_currentGroupListBox_ctrl";
	private "_index";
	_groupUnits apply {
		_index = _currentGroupListBox_ctrl lbAdd (name _x);
		if !(isPlayer _x) then {
			_currentGroupListBox_ctrl lbSetColor [_index,[0,0.31,0.65,1]];
		};
	};
	

	// leader name indicator
	private _leaderName = name (leader _selectedGroup);
	private _leaderNameIndicator_ctrl = uiNamespace getVariable "KISKA_GCH_leaderNameIndicator_ctrl";
	_leaderNameIndicator_ctrl ctrlSetText _leaderName;

	// group Id edit box/indicator
	private _groupId = groupId _selectedGroup;
	private _leaderNameIndicator_ctrl = uiNamespace getVariable "KISKA_GCH_groupIdEdit_ctrl";
	_leaderNameIndicator_ctrl ctrlSetText _groupId;

	// can delete combo
	private _canBeDeletedCombo_ctrl = uiNamespace getVariable "KISKA_GCH_canBeDeletedCombo_ctrl";
	private _canDeleteWhenEmpty = isGroupDeletedWhenEmpty _selectedGroup;
	_canBeDeletedCombo_ctrl lbSetCurSel ([0,1] select _canDeleteWhenEmpty);
	

	// can rally combo BIS_fnc_commsMenuToggleAvailability
	null = [_selectedGroup] spawn {
		params ["_group"];
		
		private _groupCanRally = [
			"KISKA_canRally",
			_group,
			false,
			2
		] call KISKA_fnc_getVariableTarget; 
		
		// make sure the menu is still open as it takes time to get a message from the server
		// also make sure the same group is selected in the list
		if (
			!isNull (uiNamespace getVariable "KISKA_GCH_display") AND
			{_selectedGroup isEqualTo (uiNamespace getVariable "KISKA_GCH_selectedGroup")}
		) then {
			private _canRallyCombo_ctrl = uiNamespace getVariable "KISKA_GCH_canRallyCombo_ctrl";
			_canRallyCombo_ctrl lbSetCurSel ([0,1] select _groupCanRally);
		};
	};

}];



// loop to update list
while {!isNull (uiNamespace getVariable "KISKA_GCH_display")} do {
	// if a group list changed, then update
	if !(allGroups isEqualTo _allGroupsCached) then {
		_allGroupsCached = allGroups;

		// check to see if players side groups actually needs to be updated
		// if no group was added to the side, no need to update
		private _sideGroups_compare = _allGroupsCached select {(side _x) isEqualTo _playerSide};
		if !(_sideGroups_compare isEqualTo _sideGroups) then {
			_sideGroups = _sideGroups_compare;
			uiNamespace setVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];
			call _fn_updateSideGroupList;
		};
	};

	sleep 2;
};