/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_removeItemFromPool

Description:
    Removes the item with the provided ID from the item pool of the given store.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.
    1: _poolItemId <STRING> - The id of the item to remove from the item pool.

Returns:
    <ANY> - whatever the removed item was

Examples:
    (begin example)
        private _removedItem = [
            "myStore",
            "KISKA_myStore_item_1"
        ] call KISKA_fnc_simpleStore_removeItemFromPool;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_removeItemFromPool";

if (!hasInterface) exitWith {};

params [
    ["_storeId","",[""]],
    ["_poolItemId","",[""]]
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

private _poolItemsMap = [_storeId] call KISKA_fnc_simpleStore_getPoolItems;
private _deletedItem = _poolItemsMap deleteAt _poolItemId;

[_storeId] call KISKA_fnc_simpleStore_refreshSelectedList;
[_storeId] call KISKA_fnc_simpleStore_refreshPoolList;


_deletedItem
