/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_updateCurrentGroupList

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
        [false] call KISKA_fnc_GCH_updateCurrentGroupList;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCH_updateCurrentGroupList"
scriptName SCRIPT_NAME;

params [
	["_showAi",uiNamespace getVariable ["KISKA_GCH_showAI",false],[true]];
];

private _selectedGroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];

if (isNull _selectedGroup) exitWith {};

private _currentGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_currentGroupListBox_ctrl";
lbClear _currentGroupListBox_ctrl;

private _groupUnits = units _selectedGroup;
if !(_showAi) then {
	_groupUnits = _groupUnits select (isPlayer _x);
};


if !(count _groupUnits > 0) exitWith {};


private "_index";
_groupUnits apply {
	_index = _currentGroupListBox_ctrl lbAdd (name _x);

	// color AI Green
	if !(isPlayer _x) then {
		_currentGroupListBox_ctrl lbSetColor [_index,[0,0.81,0,1]];
	};
};