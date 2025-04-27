/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_getPoolItems

Description:
    Gets the current map of pool items for a particular simple store id.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.

Returns:
    <HASHMAP> - The specified simple store's item map

Examples:
    (begin example)
        private _storeItemsMap = [
            "myStore"
        ] call KISKA_fnc_simpleStore_getPoolItems;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_getPoolItems";

params [
    ["_storeId","",[""]]
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

private _storeIdToPoolItemsMap = call KISKA_fnc_simpleStore_getStoreMap;
_storeId = toLowerANSI _storeId;
private _poolItemsMap = _storeIdToPoolItemsMap get _storeId;

if (isNil "_poolItemsMap") then { 
    _poolItemsMap = createHashMap;
    _storeIdToPoolItemsMap set [_storeId,_poolItemsMap];
};


_poolItemsMap
