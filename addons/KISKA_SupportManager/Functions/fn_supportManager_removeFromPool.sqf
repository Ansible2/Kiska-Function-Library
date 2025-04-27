/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_removeFromPool

Description:
    Removes the item with the provided ID from the support manager pool globally.

Parameters:
    0: _itemId <STRING> - The ID of the item in the pool to remove.

Returns:
    NOTHING

Examples:
    (begin example)
        private _itemId = [
            configFile >> "CfgCommunicationMenu" >> "MySupport"
        ] call KISKA_fnc_supportManager_addToPool;
        
        // ... some time later ...

        [_itemId] call KISKA_fnc_supportManager_removeFromPool;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_removeFromPool";

#define STORE_ID "kiska-support-manager"

if !(hasInterface) exitWith {};

params [
    ["_itemId","",[""]]
];


[STORE_ID,_itemId] call KISKA_fnc_simpleStore_removeItemFromPool_global;


nil
