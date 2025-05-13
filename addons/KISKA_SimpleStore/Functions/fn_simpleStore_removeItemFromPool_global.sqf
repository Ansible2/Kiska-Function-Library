/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_removeItemFromPool_global

Description:
    The same as `KISKA_fnc_simpleStore_removeItemFromPool` except it abstracts
    away the removal of a JIP queue message for the item to be added to the pool.

    This will execute `KISKA_fnc_simpleStore_removeItemFromPool` on all machines.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.
    1: _poolItemId <STRING> - The id of the item to remove from the item pool.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "myStore",
            "KISKA_myStore_item_1"
        ] call KISKA_fnc_simpleStore_removeItemFromPool_global;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_removeItemFromPool_global";

params [
    ["_storeId","",[""]],
    ["_poolItemId","",[""]]
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

_this remoteExecCall ["KISKA_fnc_simpleStore_removeItemFromPool",0];
// remove JIP queue message for adding the item to the pool
// see KISKA_fnc_simpleStore_addItemToPool_global
remoteExec ["",_poolItemId];