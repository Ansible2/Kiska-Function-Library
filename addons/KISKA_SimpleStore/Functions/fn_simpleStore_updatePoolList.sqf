/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_updatePoolList

Description:
    Acts as an event that will update the available supports pool list in
     the Support Manager GUI.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.

Returns:
    NOTHING

Examples:
    (begin example)
        ["myStore"] call KISKA_fnc_simpleStore_updatePoolList;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_updatePoolList";

if !(hasInterface) exitWith {};
disableSerialization;

params [
    ["_storeId","",[""]]
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

private _storeDisplay = [_storeId] call KISKA_fnc_simpleStore_getDisplay;
if (isNull _storeDisplay) exitWith {
    [["Store ",_storeId," is not open"],false] call KISKA_fnc_log;
    nil
};


private _poolItemsListControl = _storeDisplay getVariable ["KISKA_simpleStore_poolListControl",controlNull];
private _currentlySelectedIndex = lbCurSel _poolItemsListControl;
lbClear _poolItemsListControl;

private _poolItems = [_storeId] call KISKA_fnc_simpleStore_getPoolItems;
if (_poolItems isEqualTo []) exitWith { nil };


private _fn_poolItemToListboxItem = _storeDisplay getVariable "KISKA_simpleStore_fn_poolItemToListboxItem";
{
    private _listBoxItem = [_x] call _fn_poolItemToListboxItem;
    _listBoxItem params [
        ["_text","",[""]],
        ["_picture","",[""]],
        ["_pictureColor",[],[[]],4],
        ["_pictureColorSelected",[],[[]],4],
        ["_tooltip","",[""]],
        ["_data","",[""]]
    ];

    private _element = _poolItemsListControl lbAdd _text;
    _element lbSetValue _forEachIndex; // TODO: NOTE you can use this to determine the original pool item being taken
    _element lbSetTooltip _tooltip;
    _element lbSetData _data;

    if (_picture isNotEqualTo "") then {
        _element lbSetPicture _picture;
    };
    if (_pictureColor isNotEqualTo []) then {
        _element lbSetPictureColor _pictureColor;
    };
    if (_pictureColorSelected isNotEqualTo []) then {
        _element lbSetPictureColor _pictureColorSelected;
    };
} forEach _poolItems;

_poolItemsListControl lbSetSelected [_currentlySelectedIndex,true];


nil
