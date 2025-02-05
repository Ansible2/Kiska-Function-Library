#include "..\Headers\SimpleStoreCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_open

Description:
    Opens a simple store dialog/initializes it if it has not been opened prior.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.
    1: _fn_poolItemToListboxItem <CODE> - A function that will be called on every
        item in the pool items list to convert it into a listbox item to show
        in the UI. It accepts a pool item as an arguement in index 0 and must 
        return an array in the format:

            - 0: <STRING> - The text of the listbox element.
            - 1: <STRING> - Default: `""` - A path for the picture of the element.
            - 2: <ARRAY> - Default: `[]` - An RBGA array for the picture's color.
            - 3: <ARRAY> - Default: `[]` - An RBGA array for the picture's color when selected.
            - 4: <STRING> - Default: `""` - The element's tooltip.
            - 5: <STRING> - Default: `""` - The element's data property.

Returns:
    DISPLAY - The simple store dialog's display

Examples:
    (begin example)
        private _simpleStore = [
            "myStore"
        ] call KISKA_fnc_simpleStore_open;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_open";

if !(hasInterface) exitWith {};
disableSerialization;

private _currentStore = localNamespace getVariable ["KISKA_simpleStore_activeDisplay",displayNull];
if !(isNull _currentStore) exitWith {
    ["Another simple store is currently open",true] call KISKA_fnc_log;
    displayNull
};


// TODO: allow color of banner parameter?
// TODO: allow title text change of store
// TODO: allow changing of the selected items list title
// TODO: allow changing of the pool items list title
// TODO: add a function to handle adding items to the pool (and one for global use)
// TODO: add a function to handle removing items from the pool (and one for global use)
// TODO: add parameter for fetching selected items
params [
    ["_storeId","",[""]],
    ["_fn_poolItemToListboxItem",{},[{}]]
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

private _display = createDialog ["KISKA_simpleStore_dialog",false];

/* ----------------------------------------------------------------------------
    Variables
---------------------------------------------------------------------------- */
localNamespace setVariable ["KISKA_simpleStore_activeDisplay",_display];
_display setVariable ["KISKA_simpleStore_id",_storeId];
_display setVariable ["KISKA_simpleStore_poolListControl",_display displayCtrl SIMPLE_STORE_POOL_LIST_IDC];
_display setVariable ["KISKA_simpleStore_selectedListControl",_display displayCtrl SIMPLE_STORE_SELECTED_LIST_IDC];
if (_fn_poolItemToListboxItem isEqualTo {}) then {
    _fn_poolItemToListboxItem = { _this select 0 };
};
_display setVariable ["KISKA_simpleStore_fn_poolItemToListboxItem",_fn_poolItemToListboxItem];


/* ----------------------------------------------------------------------------
    Event Handlers
---------------------------------------------------------------------------- */
(_display displayCtrl SIMPLE_STORE_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    // TODO:
}];

(_display displayCtrl SIMPLE_STORE_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    // TODO:
}];

(_display displayCtrl SIMPLE_STORE_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    params ["_control"];
    private _simpleStoreDisplay = ctrlParent _control;
    _simpleStoreDisplay closeDisplay 2;
}];

_display displayAddEventHandler ["unload",{
    localNamespace setVariable ["KISKA_simpleStore_activeDisplay",nil];
}];


[_storeId] call KISKA_fnc_simpleStore_updatePoolList;


_display
