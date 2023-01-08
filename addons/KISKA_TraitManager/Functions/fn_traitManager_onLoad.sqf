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
scriptName "KISKA_fnc_traitManager_onLoad";
disableSerialization;

// check if player wants map to close when openning the manager
if (missionNamespace getVariable ["KISKA_CBA_traitManager_closeMap",true]) then {
    openMap false;
};

params ["_display"];


localNamespace setVariable [TM_DISPLAY_VAR_STR,_display];

// initialize pool list entries
_display setVariable [TM_POOL_LIST_CTRL_VAR_STR,_display displayCtrl TM_POOL_LISTBOX_IDC];
call KISKA_fnc_traitManager_updatePoolList;


// intialize current traits list
_display setVariable [TM_CURRENT_LIST_CTRL_VAR_STR,_display displayCtrl TM_CURRENT_LISTBOX_IDC];
call KISKA_fnc_traitManager_updateCurrentList;


// give buttons click events
(_display displayCtrl TM_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    call KISKA_fnc_traitManager_take_buttonClickEvent;
}];
(_display displayCtrl TM_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    call KISKA_fnc_traitManager_store_buttonClickEvent;
}];
(_display displayCtrl TM_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    GET_TM_DISPLAY closeDisplay 2;
}];


nil
