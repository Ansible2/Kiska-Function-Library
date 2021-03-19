#include "Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_onLoad

Description:
	Sets up uiNamespace globals for and intializes the Support Manager GUI.

Parameters:
	0: _display <DISPLAY> - The loaded display

Returns:
	NOTHING

Examples:
    (begin example)
		// called from config
		[_this select 0] call KISKA_fnc_supportManager_onLoad;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_onLoad";

params ["_display"];


uiNamespace setVariable ["KISKA_sm_display",_display];

// pool list loop
uiNamespace setVariable ["KISKA_SM_poolListBox_ctrl",_display displayCtrl SM_POOL_LISTBOX_IDC];
[_display] spawn KISKA_fnc_supportManager_onLoad_supportPool;


// current supports
uiNamespace setVariable ["KISKA_SM_currentListBox_ctrl",_display displayCtrl SM_CURRENT_LISTBOX_IDC];
[_display] call KISKA_fnc_supportManager_updateCurrentList;


// give buttons click events
(_display displayCtrl SM_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
	call KISKA_fnc_supportManager_take_buttonClickEvent;
}];
(_display displayCtrl SM_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
	call KISKA_fnc_supportManager_store_buttonClickEvent;
}];
(_display displayCtrl SM_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
	(uiNamespace getVariable "KISKA_sm_display") closeDisplay 2;
}];

[_display] call KISKA_fnc_supportManager_onLoad_buttons;


_display displayAddEventHandler ["unload",{
	uiNamespace setVariable ["KISKA_sm_display",nil];
	uiNamespace setVariable ["KISKA_SM_poolListBox_ctrl",nil];
	uiNamespace setVariable ["KISKA_SM_currentListBox_ctrl",nil];
}];