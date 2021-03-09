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
scriptName "KISKA_fnc_GCHOnLoad_sideGroupList";

params ["_control"];

// add event handler
_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	// get selected group
	private _sideGroups = uiNamespace getVariable "KISKA_GCH_sideGroupsArray";
	private _sideGroupsIndex = _control lbValue _selectedIndex;
	private _selectedGroup = _sideGroups select _sideGroupsIndex;
	uiNamespace setVariable ["KISKA_GCH_selectedGroup",_selectedGroup];

	[true,true,true,true,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
}];



private _playerSide = side player;
private _allGroupsCached = allGroups;
private _sideGroups = _allGroupsCached select {(side _x) isEqualTo _playerSide};
private _sideGroupIds = [];
private _fn_popSideGroupIds = {
	_sideGroupIds = [];
	_sideGroups apply {
		_sideGroupIds pushBack (groupId _x);
	};
};

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

call _fn_updateSideGroupList;


private _allGroupsCompare = [];
// loop to update list
while {!isNull (uiNamespace getVariable "KISKA_GCH_display")} do {
	// if a group list changed, then update
	if !(allGroups isEqualTo _allGroupsCached) then {
		_allGroupsCached = allGroups;

		// check to see if players side groups actually needs to be updated
		// if no group was added to the side, no need to update
		private _sideGroups_compare = _allGroupsCached select {(side _x) isEqualTo _playerSide};
		
		if !(_sideGroups_compare isEqualTo _sideGroups) then {
			_sideGroups = +_sideGroups_compare;
			uiNamespace setVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];
			call _fn_updateSideGroupList;
		};
	};

	sleep 1;
};