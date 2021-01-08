#include "..\GroupChangerCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_dialogOnLoad

Description:
	Executes in the onload event for the KISKA's Group Changer Dislog

Parameters:
	0: _display <DISPLAY> - The display of the dialog

Returns:
	NOTHING

Examples:
    (begin example)
        [_display] call KISKA_fnc_GCH_dialogOnLoad;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCH_dialogOnLoad"
scriptName SCRIPT_NAME;

disableSerialization;

params ["_display"];

// close map
openMap false;

// prepare globals for controls
uiNamespace setVariable ["KISKA_GCH_display",_display];


// join group button
private _joinGroupButton_ctrl = _display displayCtrl GCH_JOIN_GROUP_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_joinGroupButton_ctrl",_joinGroupButton_ctrl];
// leave group button
private _leaveGroupButton_ctrl = _display displayCtrl GCH_LEAVE_GROUP_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_leaveGroupButton_ctrl",_leaveGroupButton_ctrl];
// close button
private _closeButton_ctrl = _display displayCtrl GCH_CLOSE_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_closeButton_ctrl",_closeButton_ctrl];
// set leader button
private _setLeaderButton_ctrl = _display displayCtrl GCH_SET_LEADER_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_setLeaderButton_ctrl",_setLeaderButton_ctrl];
// set Group ID button
private _setGroupIdButton_ctrl = _display displayCtrl GCH_SET_GROUP_ID_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_setGroupIdButton_ctrl",_setGroupIdButton_ctrl];

[
	_joinGroupButton_ctrl,
	_leaveGroupButton_ctrl,
	_closeButton_ctrl,
	_setLeaderButton_ctrl,
	_setGroupIdButton_ctrl
] call KISKA_fnc_GCH_buttonsOnLoad;


// edit
private _groupIdEdit_ctrl = _display displayCtrl GCH_SET_GROUP_ID_EDIT_IDC;
uiNamespace setVariable ["KISKA_GCH_groupIdEdit_ctrl",_groupIdEdit_ctrl];


// side groups list
private _sidesGroupListBox_ctrl = _display displayCtrl GCH_SIDE_GROUPS_LISTBOX_IDC;
uiNamespace setVariable ["KISKA_GCH_sidesGroupListBox_ctrl",_sidesGroupListBox_ctrl];
// current group unit list
private _currentGroupListBox_ctrl = _display displayCtrl GCH_CURRENT_GROUP_LISTBOX_IDC;
uiNamespace setVariable ["KISKA_GCH_currentGroupListBox_ctrl",_currentGroupListBox_ctrl];


// combos
private _canBeDeletedCombo_ctrl = _display displayCtrl GCH_CAN_BE_DELETED_COMBO_IDC;
uiNamespace setVariable ["KISKA_GCH_canBeDeletedCombo_ctrl",_canBeDeletedCombo_ctrl];

private _canRallyCombo_ctrl = _display displayCtrl GCH_CAN_RALLY_COMBO_IDC;
uiNamespace setVariable ["KISKA_GCH_canRallyCombo_ctrl",_canRallyCombo_ctrl];


// leader name indicator
private _leaderNameIndicator_ctrl = _display displayCtrl GCH_LEADER_NAME_INDICATOR_IDC;
uiNamespace setVariable ["KISKA_GCH_leaderNameIndicator_ctrl",_leaderNameIndicator_ctrl];
// can be deleted indicator
private _canBeDeletedIndicator_ctrl = _display displayCtrl GCH_CAN_BE_DELETED_INDICATOR_IDC;
uiNamespace setVariable ["KISKA_GCH_canBeDeletedIndicator_ctrl",_canBeDeletedIndicator_ctrl];


// Show AI Check Box
private _showAiCheckBox_ctrl = _display displayCtrl GCH_SHOW_AI_CHECKBOX_IDC;
uiNamespace setVariable ["KISKA_GCH_showAiCheckBox_ctrl",_showAiCheckBox_ctrl];




_display displayAddEventHandler ["unload",{
	// get rid of any hints
	hintSilent "";

	// clear uiNamespace variables
	[
		"KISKA_GCH_display",
		"KISKA_GCH_joinGroupButton_ctrl",
		"KISKA_GCH_leaveGroupButton_ctrl",
		"KISKA_GCH_closeButton_ctrl",
		"KISKA_GCH_sidesGroupListBox_ctrl",
		"KISKA_GCH_currentGroupListBox_ctrl",
		"KISKA_GCH_canRallyIndicator_ctrl",
		"KISKA_GCH_leaderNameIndicator_ctrl",
		"KISKA_GCH_canBeDeletedIndicator_ctrl",
		"KISKA_GCH_leaderIsPlayerIndicator_ctrl",
		"KISKA_GCH_showAiCheckBox_ctrl"
	] apply {
		uiNamespace setVariable [_x,nil];
	};
	
}];


// there needs to be a variable you can assign to units/players that does not allow them to leave groups
// or it only allows them to join certain groups