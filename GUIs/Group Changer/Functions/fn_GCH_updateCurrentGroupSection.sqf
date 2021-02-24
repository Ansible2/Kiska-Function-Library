/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_updateCurrentGroupSection

Description:
	Updates the current group list in the GCH GUI with either showing AI in a
	 group or not

Parameters:
	0: _showAi <BOOL> - true to include AI in the list, false to not

Returns:
	NOTHING

Examples:
    (begin example)
		// update list to not show AI
        [false] call KISKA_fnc_GCH_updateCurrentGroupSection;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define COLOR_BLUE [0,0.24,0.59,1]
#define COLOR_RED [1,0,0,0.62]
#define COLOR_GREEN [0,1,0,0.6]
#define COLOR_YELLOW [1,1,0,0.8]

#define SCRIPT_NAME "KISKA_fnc_GCH_updateCurrentGroupSection"
scriptName SCRIPT_NAME;

params [
	["_updateUnitList",false,[true]],
	["_updateLeaderIndicator",false,[true]],
	["_updateGroupId",false,[true]],
	["_updateCanDeleteCombo",false,[true]],
	["_updateCanRallyCombo",false,[true]]
];

private _selectedGroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];

if (isNull _selectedGroup) exitWith {};

if (_updateUnitList) then {
	private _currentGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_currentGroupListBox_ctrl";
	lbClear _currentGroupListBox_ctrl;

	private _groupUnits = units _selectedGroup;
	if !(uiNamespace getVariable "KISKA_GCH_showAI") then {
		_groupUnits = _groupUnits select {isPlayer _x};
	};

	uiNamespace setVariable ["KISKA_GCH_groupUnitList",_groupUnits];

	if !(count _groupUnits > 0) exitWith {};

	
	private ["_index","_team"];
	private _fn_setTeamColor = {
		// don't change white team
		if (_team == "MAIN" OR {_team == ""}) exitWith {};

		if (_team == "GREEN") exitWith {
			_currentGroupListBox_ctrl lbSetColor [_index,COLOR_GREEN];
		};
		if (_team == "YELLOW") exitWith {
			_currentGroupListBox_ctrl lbSetColor [_index,COLOR_YELLOW];
		};
		if (_team == "RED") exitWith {
			_currentGroupListBox_ctrl lbSetColor [_index,COLOR_RED];
		};
		if (_team == "BLUE") exitWith {
			_currentGroupListBox_ctrl lbSetColor [_index,COLOR_BLUE];
		};
	};

	{
		_index = _currentGroupListBox_ctrl lbAdd (name _x);
		// store index value in array before we sort alphabetically
		_currentGroupListBox_ctrl lbSetValue [_index,_forEachIndex];
		
		// color AI Green
		if !(isPlayer _x) then {
			_currentGroupListBox_ctrl lbSetTooltip [_index,"AI"];
		};

		_team = assignedTeam _x;
		call _fn_setTeamColor;
		
	} forEach _groupUnits;

	lbSort _currentGroupListBox_ctrl;
};


if (_updateLeaderIndicator) then {
	private _leader = leader _selectedGroup;
	private "_leaderName";
	if (isNull _leader) then {
		_leaderName = "NO LEADER";
	} else {
		_leaderName = name _leader;
	};
	private _leaderNameIndicator_ctrl = uiNamespace getVariable "KISKA_GCH_leaderNameIndicator_ctrl";
	_leaderNameIndicator_ctrl ctrlSetText _leaderName;
};


if (_updateGroupId) then {
	private _groupId = groupId _selectedGroup;
	private _groupEditId_ctrl = uiNamespace getVariable "KISKA_GCH_groupIdEdit_ctrl";
	_groupEditId_ctrl ctrlSetText _groupId;
};


if (_updateCanDeleteCombo) then {
	private _canBeDeletedCombo_ctrl = uiNamespace getVariable "KISKA_GCH_canBeDeletedCombo_ctrl";
	private _canDeleteWhenEmpty = isGroupDeletedWhenEmpty _selectedGroup;
	_canBeDeletedCombo_ctrl lbSetCurSel ([0,1] select _canDeleteWhenEmpty);
};


if (_updateCanRallyCombo) then {
	[_selectedGroup] spawn {
		params ["_selectedGroup"];
		
		private _groupCanRally = [
			"KISKA_canRally",
			_selectedGroup,
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
};








/*
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
*/	
