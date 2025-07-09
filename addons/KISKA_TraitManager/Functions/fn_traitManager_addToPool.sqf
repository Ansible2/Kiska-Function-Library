/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_addToPool

Description:
    Adds an entry into the support manager pool globally.

Parameters:
    0: _traitConfig <CONFIG | STRING> - The config of a trait or a string of a class 
        that is in a `KISKA_Traits` class in either the 
        `missionConfigFile`, `campaignConfigFile`, or `configFile`.

Returns:
    <STRING> - the item's global identifier which is also used for the JIP queue.

Examples:
    (begin example)
        "someClassInKISKA_Traits" call KISKA_fnc_traitManager_addToPool;
    (end)

    (begin example)
        private _itemId = [
            configFile >> "Traits" >> "MyTrait"
        ] call KISKA_fnc_traitManager_addToPool;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_addToPool";

#define STORE_ID "kiska-trait-manager"

if !(hasInterface) exitWith {};

params [
    ["_traitConfig",configNull,[configNull,""]],
    ["_numberOfUsesLeft",-1,[123]]
];

if (_traitConfig isEqualType "") then {
    _traitConfig = [["KISKA_Traits",_traitConfig]] call KISKA_fnc_findConfigAny;
};
if (isNull _traitConfig) exitWith {
    ["Could not find _traitConfig",true] call KISKA_fnc_log;
    nil
};


private _itemId = [
    STORE_ID,
    _traitConfig
] call KISKA_fnc_simpleStore_addItemToPool_global;


_itemId
