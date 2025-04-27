/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_addItemToPool

Description:
    Adds an entry into the local Simple Store pool for the given id.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.
    1: _itemToAdd <ANY> - Whatever value that is meant to be added.
    2: _itemId <STRING> Default: `{_storeId}_item_{number}` - A unique identifier
        for the item. If one is not provided, an ID is generated using `KISKA_fnc_generateUniqueId`.

Returns:
    <STRING> - the item's `_itemId`

Examples:
    (begin example)
        [
            "myStore",
            "MyValue"
        ] call KISKA_fnc_simpleStore_addItemToPool;
    (end)

    (begin example)
        [
            "myStore",
            "MyValue",
            "KISKA_itemId"
        ] call KISKA_fnc_simpleStore_addItemToPool;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_addItemToPool";

if (!hasInterface) exitWith {};

params [
    ["_storeId","",[""]],
    "_itemToAdd",
    ["_itemId","",[""]]
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

// TODO 176: change to map
private _poolItemsMap = [_storeId] call KISKA_fnc_simpleStore_getPoolItems;
if (_itemId isEqualTo "") then {
    _itemId = [[_storeId,"item"] joinString "_"] call KISKA_fnc_generateUniqueId;
};
_poolItemsMap set [_itemId,_itemToAdd];

[_storeId] call KISKA_fnc_simpleStore_refreshSelectedList;
[_storeId] call KISKA_fnc_simpleStore_refreshPoolList;


_itemId
