#include "..\Headers\Support Manager Common Defines.hpp"
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
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_onLoad";
disableSerialization;

// check if player wants map to close when openning the manager
if (missionNamespace getVariable ["KISKA_CBA_supportManager_closeMap",true]) then {
    openMap false;
};

params ["_display"];


localNamespace setVariable [SM_DISPLAY_VAR_STR,_display];

// initialize pool list entries
_display setVariable [SM_POOL_LIST_CTRL_VAR_STR,_display displayCtrl SM_POOL_LISTBOX_IDC];
call KISKA_fnc_supportManager_updatePoolList;


// intialize current supports list
_display setVariable [SM_CURRENT_LIST_CTRL_VAR_STR,_display displayCtrl SM_CURRENT_LISTBOX_IDC];
call KISKA_fnc_supportManager_updateCurrentList;


// give buttons click events
(_display displayCtrl SM_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    call KISKA_fnc_supportManager_take_buttonClickEvent;
}];
(_display displayCtrl SM_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    call KISKA_fnc_supportManager_store_buttonClickEvent;
}];
(_display displayCtrl SM_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    GET_SM_DISPLAY closeDisplay 2;
}];


nil
