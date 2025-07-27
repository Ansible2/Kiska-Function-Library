#include "..\Headers\SimpleStoreCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_open

Description:
    Opens a simple store dialog/initializes it if it has not been opened prior.

Parameters:
    0: _paramsMap : <HASHMAP> - A hashmap of the following arguments:
        - `_storeId` <STRING>: The id for the particular simple store.
        - `_fn_poolItemToListboxItem` <CODE>: A mapping function that will be called on every
            item in the pool items list to convert it into a listbox item to show
            in the UI. In the event that the function returns `nil` the item will
            be excluded from the pool list. 

                Parameters: 
                
                - 0: <ANY> - A pool item.
                - 1: <NUMBER> - The index of the item in the pool.

                Should return an array containing:

                - 0: <STRING> - The text of the listbox element.
                - 1: <STRING> - Default: `""` - A path for the picture of the element.
                - 2: <ARRAY> - Default: `[]` - An RBGA array for the picture's color.
                - 3: <ARRAY> - Default: `[]` - An RBGA array for the picture's color when selected.
                - 4: <STRING> - Default: `""` - The element's tooltip.
        
        - `_fn_getSelectedItems` <CODE>: A function that will be called whenever
            `KISKA_fnc_simpleStore_refreshSelectedList` is. Must return an array of
            items formatted the same as an item returned from `_fn_poolItemToListboxItem`
            with the addition of index 5 being the listbox item's `data` property.

            Passed the following args:
                
                - 0: <STRING> - The store id.

        - `_fn_onTake` <CODE>: A function that will be called when the Take button 
            is clicked. Passed the following args:

                - 0: <STRING> - The store id.
                - 1: <ANY> - Whatever the item from the pool that was selected.
                - 2: <STRING> - The item's id from the pool items map retrieved from 
                    `KISKA_fnc_simpleStore_getPoolItems`. Will be an empty string (`""`)
                    if no item is selected.

        - `_fn_onStore` <CODE>: A function that will be called when the Store button 
            is clicked. Passed the following args:

                - 0: <STRING> - The store id.
                - 1: <STRING> - The item's `lbData`.
                - 2: <NUMBER> - The index of the selected item in the selected items list. 
                    This is the index of the source array, not the index in the list box.

        - `_storeTitle` <STRING>: Default `"KISKA Simple Store"` - The text that appears at on the top banner.
        - `_storePoolTitle` <STRING>: Default `"Pool List"` - The text that appears 
            above the pool list to identify it.
        - `_storeSelectedItemsTitle` <STRING>: Default `"Selected List"` - The text that appears 
            above the selected items list to identify it.
        - `_headerBannerBackgroundColor` <COLOR(RGBA)>: Default `profile color` - The color 
            of the store title header.

Returns:
    <DISPLAY> - The simple store dialog's display

Examples:
    (begin example)
        myStoreSelectedItems = [];
        private _args = createHashMapFromArray [
            ["_storeId","myStore"],
            ["_fn_getSelectedItems",{myStoreSelectedItems}],
            [
                "_fn_onTake",
                {
                    params ["_storeId","_itemId"];
                    _this call KISKA_fnc_simpleStore_removeItemFromPool;
                }
            ],
            [
                "_fn_onStore",
                {
                    params ["_storeId","_data","_index"];
                    [
                        _storeId,
                        myStoreSelectedItems deleteAt _index
                    ] call KISKA_fnc_simpleStore_addItemToPool;
                }
            ]
        ];
        _args call KISKA_fnc_simpleStore_open;
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

private _paramsMap = _this;
private _paramDetails = [
    ["_storeId",{""},[""]],
    ["_fn_poolItemToListboxItem",{{ _this select 0 }},[{}]],
    ["_fn_getSelectedItems",{{}},[{}]],
    ["_fn_onTake",{{}},[{}]],
    ["_fn_onStore",{{}},[{}]],
    ["_storeTitle",{"KISKA Simple Store"},[""]],
    ["_storePoolTitle",{"Pool List"},[""]],
    ["_storeSelectedItemsTitle",{"Selected List"},[""]],
    [
        "_headerBannerBackgroundColor",
        {
            [
                (profilenamespace getvariable ['GUI_BCG_RGB_R',0.13]),
                (profilenamespace getvariable ['GUI_BCG_RGB_G',0.54]),
                (profilenamespace getvariable ['GUI_BCG_RGB_B',0.21]),
                1
            ]
        },
        [[]]
    ]
];

private _paramValidationResult = [_paramsMap,_paramDetails] call KISKA_fnc_hashMapParams;
if (_paramValidationResult isEqualType "") exitWith {
    [_paramValidationResult,true] call KISKA_fnc_log;
    nil
};
(_paramValidationResult select 0) params (_paramValidationResult select 1);


if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    displayNull
};

if (_fn_getSelectedItems call KISKA_fnc_isEmptyCode) exitWith {
    ["_fn_getSelectedItems is empty, it must be implemented",true] call KISKA_fnc_log;
    displayNull
};
if (_fn_onTake call KISKA_fnc_isEmptyCode) exitWith {
    ["_fn_onTake is empty, it must be implemented",true] call KISKA_fnc_log;
    displayNull
};
if (_fn_onStore call KISKA_fnc_isEmptyCode) exitWith {
    ["_fn_onStore is empty, it must be implemented",true] call KISKA_fnc_log;
    displayNull
};

private _display = createDialog ["KISKA_simpleStore_dialog",false];
private _storeHeaderControl = _display displayCtrl SIMPLE_STORE_HEADER_TEXT_IDC;
_storeHeaderControl ctrlSetBackgroundColor _headerBannerBackgroundColor;
_storeHeaderControl ctrlSetText _storeTitle;
(_display displayCtrl SIMPLE_STORE_POOL_HEADER_TEXT_IDC) ctrlSetText _storePoolTitle;
(_display displayCtrl SIMPLE_STORE_SELECTED_HEADER_TEXT_IDC) ctrlSetText _storeSelectedItemsTitle;


/* ----------------------------------------------------------------------------
    Variables
---------------------------------------------------------------------------- */
localNamespace setVariable ["KISKA_simpleStore_activeDisplay",_display];
_display setVariable ["KISKA_simpleStore_id",_storeId];
_display setVariable ["KISKA_simpleStore_poolListControl",_display displayCtrl SIMPLE_STORE_POOL_LIST_IDC];
_display setVariable ["KISKA_simpleStore_selectedListControl",_display displayCtrl SIMPLE_STORE_SELECTED_LIST_IDC];
_display setVariable ["KISKA_simpleStore_fn_getSelectedItems",_fn_getSelectedItems];
_display setVariable ["KISKA_simpleStore_fn_onStore",_fn_onStore];
_display setVariable ["KISKA_simpleStore_fn_onTake",_fn_onTake];
_display setVariable ["KISKA_simpleStore_fn_poolItemToListboxItem",_fn_poolItemToListboxItem];


/* ----------------------------------------------------------------------------
    Event Handlers
---------------------------------------------------------------------------- */
(_display displayCtrl SIMPLE_STORE_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick", {
    params ["_buttonControl"];

    private _simpleStoreDisplay = ctrlParent _buttonControl;
    private _poolListControl = _simpleStoreDisplay getVariable "KISKA_simpleStore_poolListControl";
    private _selectedListboxIndex = lbCurSel _poolListControl;

    if (
        _selectedListboxIndex >= 0 AND 
        // if a user selects an item and then clicks the button again
        // lbCurSel still returns the index of the previously selected one
        {(_poolListControl lbText _selectedListboxIndex) isNotEqualTo ""}
    ) then {
        private _selectedItemId = _poolListControl lbData _selectedListboxIndex;
        private _storeId = _simpleStoreDisplay getVariable "KISKA_simpleStore_id";
        private _poolItemsMap = [_storeId] call KISKA_fnc_simpleStore_getPoolItems;
        private _selectedItem = _poolItemsMap get _selectedItemId;
        [
            _storeId,
            _selectedItem,
            _selectedItemId
        ] call (_simpleStoreDisplay getVariable "KISKA_simpleStore_fn_onTake");
    };
}];

(_display displayCtrl SIMPLE_STORE_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick", {
    params ["_buttonControl"];
    private _simpleStoreDisplay = ctrlParent _buttonControl;
    private _selectedListControl = _simpleStoreDisplay getVariable "KISKA_simpleStore_selectedListControl";
    private _selectedListboxIndex = lbCurSel _selectedListControl;

    if (
        _selectedListboxIndex >= 0 AND 
        // if a user selects an item and then clicks the button again
        // lbCurSel still returns the index of the previously selected one
        {(_selectedListControl lbText _selectedListboxIndex) isNotEqualTo ""}
    ) then {
        [
            _simpleStoreDisplay getVariable "KISKA_simpleStore_id",
            _selectedListControl lbData _selectedListboxIndex,
            _selectedListboxIndex
        ] call (_simpleStoreDisplay getVariable "KISKA_simpleStore_fn_onStore");
    };
}];

(_display displayCtrl SIMPLE_STORE_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _simpleStoreDisplay = ctrlParent _control;
    _simpleStoreDisplay closeDisplay 2;
}];

_display displayAddEventHandler ["unload",{
    localNamespace setVariable ["KISKA_simpleStore_activeDisplay",nil];
}];


[_storeId] call KISKA_fnc_simpleStore_refreshSelectedList;
[_storeId] call KISKA_fnc_simpleStore_refreshPoolList;


_display
