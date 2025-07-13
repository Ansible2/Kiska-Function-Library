/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_removeFromPool

Description:
    Removes the item with the provided ID from the trait manager pool globally.

Parameters:
    0: _itemId <STRING> - The ID of the item in the pool to remove.

Returns:
    NOTHING

Examples:
    (begin example)
        private _itemId = [
            configFile >> "KISKA_Traits" >> "MyTrait"
        ] call KISKA_fnc_traitManager_addToPool;
        
        // ... some time later ...

        _itemId call KISKA_fnc_traitManager_removeFromPool;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_removeFromPool";

#define STORE_ID "kiska-trait-manager"

if !(hasInterface) exitWith {};

params [
    ["_itemId","",[""]]
];


[STORE_ID,_itemId] call KISKA_fnc_simpleStore_removeItemFromPool_global;


nil
