/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_getStoreMap

Description:
    Gets the global map that stores the store id and what the current pool items
    list is.

Parameters:
    NONE

Returns:
    HASHMAP - The data which maps a store id to it's pool list.

Examples:
    (begin example)
        private _storeIdToPoolItemsMap = call KISKA_fnc_simpleStore_getStoreMap;
        private _myStoresPoolItems = _storeIdToPoolItemsMap get "myStore";
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_getStoreMap";


private _map = localNamespace getVariable "KISKA_simpleStore_storeIdToPoolItemsMap";
if !(isNil "_map") exitWith { _map };

_map = createHashMap;
localNamespace setVariable ["KISKA_simpleStore_storeIdToPoolItemsMap",_map];


_map
