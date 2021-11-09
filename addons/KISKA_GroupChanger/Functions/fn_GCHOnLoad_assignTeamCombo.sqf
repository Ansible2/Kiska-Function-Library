#include "..\Headers\GCH Colors.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_assignTeamCombo

Description:
	Adds control event handler to the combo box for turning it on and off.

Parameters:
	0: _control <CONTROL> - The control for the combo box

Returns:
	NOTHING

Examples:
    (begin example)
        [_control] call KISKA_fnc_GCHOnLoad_assignTeamCombo;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad_assignTeamCombo";


params ["_control"];

_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	private _unitList = uiNamespace getVariable ["KISKA_GCH_groupUnitList",[]];
	private _currentGroupListBox_ctrl = uiNamespace getVariable "KISKA_GCH_currentGroupListBox_ctrl";
	private _unitLBIndex = lbCurSel _currentGroupListBox_ctrl;
	private _selectedUnit = _unitList select (_currentGroupListBox_ctrl lbValue _unitLBIndex);

	private _selectedgroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];
	private _groupLeader = leader _selectedgroup;

	private _unitIsPlayer = _selectedUnit isEqualTo player;
	if (_unitIsPlayer OR {_groupLeader isEqualTo player} OR {call KISKA_fnc_isAdminOrHost}) then {
		if (alive _selectedUnit) then {
			[_selectedUnit,_selectedIndex] remoteExec ["KISKA_fnc_GCH_assignTeam",[_groupLeader,_selectedUnit] select (_unitIsPlayer)];
			[] spawn {
				sleep 1;
				[true] call KISKA_fnc_GCH_updateCurrentGroupSection;
			};

		} else {
			["This unit appears to be dead"] call KISKA_fnc_errorNotification;

		};

	} else {
		["You must be the admin or host to change this setting"] call KISKA_fnc_errorNotification;

	};

}];

_control lbAdd "MAIN";

private _index = _control lbAdd "BLUE";
_control lbSetColor [_index, COLOR_BLUE];

_index = _control lbAdd "GREEN";
_control lbSetColor [_index, COLOR_GREEN];

_index = _control lbAdd "RED";
_control lbSetColor [_index, COLOR_RED];

_index = _control lbAdd "YELLOW";
_control lbSetColor [_index, COLOR_YELLOW];


_control lbSetCurSel 0;


nil
