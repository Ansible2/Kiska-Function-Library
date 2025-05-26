/* ----------------------------------------------------------------------------
Function: KISKA_fnc_simpleStore_addItemToPool_global

Description:
    The same as `KISKA_fnc_simpleStore_addItemToPool` except it abstracts away the
    generating of an item's id and handling of JIP messages. Ideally should be used
    in conjunction with `KISKA_fnc_simpleStore_removeItemFromPool_global`.

    This will trigger an execution of `KISKA_fnc_simpleStore_addItemToPool` on all
    machines and add a JIP queue message.

Parameters:
    0: _storeId <STRING> - The id for the particular simple store.
    1: _itemToAdd <ANY> - Whatever value that is meant to be added.

Returns:
    <STRING> - the item's global identifier which is also used for the JIP queue.

Examples:
    (begin example)
        private _itemId = [
            "myStore",
            "MyValue"
        ] call KISKA_fnc_simpleStore_addItemToPool_global;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_simpleStore_addItemToPool_global";

params [
    ["_storeId","",[""]],
    "_itemToAdd"
];

if (_storeId isEqualTo "") exitWith {
    ["_storeId is empty!",true] call KISKA_fnc_log;
    nil
};

private _itemId = [[_storeId,"item"] joinString "_"] call KISKA_fnc_generateUniqueId;
[_storeId,_itemToAdd,_itemId] remoteExecCall ["KISKA_fnc_simpleStore_addItemToPool",0,_itemId];


_itemId
