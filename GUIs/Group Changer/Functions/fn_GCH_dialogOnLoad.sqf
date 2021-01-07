#include "..\GroupChangerCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_dialogOnLoad

Description:
	

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

// prepare globals for controls
uiNamespace setVariable ["KISKA_GCH_display",_display];


// join group button
private _joinGroupButton_ctrl = _display displayCtrl GROUP_CHANGER_JOIN_GROUP_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_joinGroupButton_ctrl",_joinGroupButton_ctrl];
// leave group button
private _leaveGroupButton_ctrl = _display displayCtrl GROUP_CHANGER_LEAVE_GROUP_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_leaveGroupButton_ctrl",_leaveGroupButton_ctrl];
// close button
private _closeButton_ctrl = _display displayCtrl GROUP_CHANGER_CLOSE_BUTTON_IDC;
uiNamespace setVariable ["KISKA_GCH_closeButton_ctrl",_closeButton_ctrl];


// side groups list
private _sidesGroupListBox_ctrl = _display displayCtrl GROUP_CHANGER_SIDE_GROUPS_LISTBOX_IDC;
uiNamespace setVariable ["KISKA_GCH_sidesGroupListBox_ctrl",_sidesGroupListBox_ctrl];
// current group unit list
private _currentGroupListBox_ctrl = _display displayCtrl GROUP_CHANGER_CURRENT_GROUP_LISTBOX_IDC;
uiNamespace setVariable ["KISKA_GCH_currentGroupListBox_ctrl",_currentGroupListBox_ctrl];


// can rally indicator
private _canRallyIndicator_ctrl = _display displayCtrl GROUP_CHANGER_CAN_RALLY_INDICATOR_IDC;
uiNamespace setVariable ["KISKA_GCH_canRallyIndicator_ctrl",_canRallyIndicator_ctrl];
// leader name indicator
private _leaderNameIndicator_ctrl = _display displayCtrl GROUP_CHANGER_LEADER_NAME_INDICATOR_IDC;
uiNamespace setVariable ["KISKA_GCH_leaderNameIndicator_ctrl",_leaderNameIndicator_ctrl];
// can be deleted indicator
private _canBeDeletedIndicator_ctrl = _display displayCtrl GROUP_CHANGER_CAN_BE_DELETED_INDICATOR_IDC;
uiNamespace setVariable ["KISKA_GCH_canBeDeletedIndicator_ctrl",_canBeDeletedIndicator_ctrl];
// leader is player indicator
private _leaderIsPlayerIndicator_ctrl = _display displayCtrl GROUP_CHANGER_LEADER_IS_PLAYER_INDICATOR_IDC;
uiNamespace setVariable ["KISKA_GCH_leaderIsPlayerIndicator_ctrl",_leaderIsPlayerIndicator_ctrl];


// Show AI Check Box
private _showAiCheckBox_ctrl = _display displayCtrl GROUP_CHANGER_SHOW_AI_CHECKBOX_IDC;
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