#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_onLoad

Description:
	Sets up uiNamespace globals for and intializes the Trait Manager GUI.

Parameters:
	0: _display <DISPLAY> - The loaded display

Returns:
	NOTHING

Examples:
    (begin example)
		// called from config
		[_this select 0] call KISKA_fnc_traitManager_onLoad;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_onLoad";

if (missionNamespace getVariable ["KISKA_CBA_traitManager_closeMap",true]) then {
	openMap false;
};

params ["_display"];


uiNamespace setVariable ["KISKA_tm_display",_display];

// pool list loop
uiNamespace setVariable ["KISKA_TM_poolListBox_ctrl",_display displayCtrl TM_POOL_LISTBOX_IDC];
[_display] spawn KISKA_fnc_traitManager_onLoad_traitPool;


// current supports
uiNamespace setVariable ["KISKA_TM_currentListBox_ctrl",_display displayCtrl TM_CURRENT_LISTBOX_IDC];
call KISKA_fnc_traitManager_updateCurrentList;


// give buttons click events
(_display displayCtrl TM_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
	call KISKA_fnc_traitManager_take_buttonClickEvent;
}];
(_display displayCtrl TM_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
	call KISKA_fnc_traitManager_store_buttonClickEvent;
}];
(_display displayCtrl TM_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
	(uiNamespace getVariable "KISKA_tm_display") closeDisplay 2;
}];


_display displayAddEventHandler ["unload",{
	uiNamespace setVariable ["KISKA_tm_display",nil];
	uiNamespace setVariable ["KISKA_TM_poolListBox_ctrl",nil];
	uiNamespace setVariable ["KISKA_TM_currentListBox_ctrl",nil];
}];


nil
