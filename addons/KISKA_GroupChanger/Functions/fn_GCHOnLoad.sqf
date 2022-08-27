#include "..\Headers\GroupChangerCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad

Description:
	Executes in the onload event for the KISKA's Group Changer Dislog

Parameters:
	0: _display <DISPLAY> - The display of the dialog

Returns:
	NOTHING

Examples:
    (begin example)
        [_display] call KISKA_fnc_GCHOnLoad;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad";

if !(hasInterface) exitWith {};

params ["_display"];

if (missionNamespace getVariable ["KISKA_CBA_GCH_closeMap",true]) then {
	openMap false;
};

// prepare globals for controls
localNamespace setVariable ["KISKA_GCH_display",_display];


/* ----------------------------------------------------------------------------
	Misc
---------------------------------------------------------------------------- */
// leader name indicator
private _leaderNameIndicator_ctrl = _display displayCtrl GCH_LEADER_NAME_INDICATOR_IDC;
localNamespace setVariable ["KISKA_GCH_leaderNameIndicator_ctrl",_leaderNameIndicator_ctrl];


// Show AI Check Box
private _showAiCheckBox_ctrl = _display displayCtrl GCH_SHOW_AI_CHECKBOX_IDC;
localNamespace setVariable ["KISKA_GCH_showAiCheckBox_ctrl",_showAiCheckBox_ctrl];
[_showAiCheckBox_ctrl] call KISKA_fnc_GCHOnLoad_showAiCheckbox;


/* ----------------------------------------------------------------------------
	Combo Boxes
---------------------------------------------------------------------------- */
// can be deleted
private _canBeDeletedCombo_ctrl = _display displayCtrl GCH_CAN_BE_DELETED_COMBO_IDC;
localNamespace setVariable ["KISKA_GCH_canBeDeletedCombo_ctrl",_canBeDeletedCombo_ctrl];
[_canBeDeletedCombo_ctrl] call KISKA_fnc_GCHOnLoad_canBeDeletedCombo;

// can rally
private _canRallyCombo_ctrl = _display displayCtrl GCH_CAN_RALLY_COMBO_IDC;
localNamespace setVariable ["KISKA_GCH_canRallyCombo_ctrl",_canRallyCombo_ctrl];
[_canRallyCombo_ctrl] call KISKA_fnc_GCHOnLoad_canRallyCombo;

// Assign Team
private _assignTeamCombo_ctrl = _display displayCtrl GCH_CAN_ASSIGN_TEAM_COMBO_IDC;
localNamespace setVariable ["KISKA_GCH_assignTeamCombo_ctrl",_assignTeamCombo_ctrl];
[_assignTeamCombo_ctrl] call KISKA_fnc_GCHOnLoad_assignTeamCombo;


/* ----------------------------------------------------------------------------
	List Boxes
---------------------------------------------------------------------------- */
// current group unit list
private _currentGroupListBox_ctrl = _display displayCtrl GCH_CURRENT_GROUP_LISTBOX_IDC;
localNamespace setVariable ["KISKA_GCH_currentGroupListBox_ctrl",_currentGroupListBox_ctrl];

// side groups list
private _sidesGroupListBox_ctrl = _display displayCtrl GCH_SIDE_GROUPS_LISTBOX_IDC;
localNamespace setVariable ["KISKA_GCH_sidesGroupListBox_ctrl",_sidesGroupListBox_ctrl];
[_sidesGroupListBox_ctrl] call KISKA_fnc_GCHOnLoad_sideGroupsList;


/* ----------------------------------------------------------------------------
	Buttons
---------------------------------------------------------------------------- */
// join group button
private _joinGroupButton_ctrl = _display displayCtrl GCH_JOIN_GROUP_BUTTON_IDC;
localNamespace setVariable ["KISKA_GCH_joinGroupButton_ctrl",_joinGroupButton_ctrl];
[_joinGroupButton_ctrl] call KISKA_fnc_GCHOnLoad_joinGroupButton;

// leave group button
private _leaveGroupButton_ctrl = _display displayCtrl GCH_LEAVE_GROUP_BUTTON_IDC;
localNamespace setVariable ["KISKA_GCH_leaveGroupButton_ctrl",_leaveGroupButton_ctrl];
[_leaveGroupButton_ctrl] call KISKA_fnc_GCHOnLoad_leaveGroupButton;

// close button
private _closeButton_ctrl = _display displayCtrl GCH_CLOSE_BUTTON_IDC;
//localNamespace setVariable ["KISKA_GCH_closeButton_ctrl",_closeButton_ctrl];
[_closeButton_ctrl] call KISKA_fnc_GCHOnLoad_closeButton;

// set leader button
private _setLeaderButton_ctrl = _display displayCtrl GCH_SET_LEADER_BUTTON_IDC;
localNamespace setVariable ["KISKA_GCH_setLeaderButton_ctrl",_setLeaderButton_ctrl];
[_setLeaderButton_ctrl] call KISKA_fnc_GCHOnLoad_setLeaderButton;

// set Group ID button
private _setGroupIdButton_ctrl = _display displayCtrl GCH_SET_GROUP_ID_BUTTON_IDC;
localNamespace setVariable ["KISKA_GCH_setGroupIdButton_ctrl",_setGroupIdButton_ctrl];
// edit
private _groupIdEdit_ctrl = _display displayCtrl GCH_SET_GROUP_ID_EDIT_IDC;
localNamespace setVariable ["KISKA_GCH_groupIdEdit_ctrl",_groupIdEdit_ctrl];
[_setGroupIdButton_ctrl] call KISKA_fnc_GCHOnLoad_setGroupIdButton;







_display displayAddEventHandler ["unload",{
	// clear localNamespace variables
	[
		"KISKA_GCH_display",
		"KISKA_GCH_selectedGroup",
		"KISKA_GCH_currentGroupListBox_ctrl",
		"KISKA_GCH_leaveGroupButton_ctrl",
		"KISKA_GCH_groupUnitList",
		"KISKA_GCH_leaderNameIndicator_ctrl",
		"KISKA_GCH_setLeaderButton_ctrl",
		"KISKA_GCH_joinGroupButton_ctrl",
		"KISKA_GCH_showAiCheckBox_ctrl",
		"KISKA_GCH_groupIdEdit_ctrl",
		"KISKA_GCH_canBeDeletedCombo_ctrl",
		"KISKA_GCH_canRallyCombo_ctrl",
		"KISKA_GCH_sidesGroupListBox_ctrl",
		"KISKA_GCH_sideGroupsArray",
		"KISKA_GCH_setGroupIdButton_ctrl",
		"KISKA_GCH_assignTeamCombo_ctrl"
	] apply {
		localNamespace setVariable [_x,nil];
	};
}];


// there needs to be a variable you can assign to units/players that does not allow them to leave groups
// or it only allows them to join certain groups
