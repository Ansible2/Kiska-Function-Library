/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_getMap

Description:
    Retrieves the hashmap that contains a players current supports in the 
    communication menu.

Parameters:
    NONE

Returns:
    <HASHMAP> - The hashmap containing information about the player's supports
        that are used in the comm menu.

Examples:
    (begin example)
        private _supportMap = call KISKA_fnc_commMenu_getMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_getMap";

[
    localNamespace,
    "KISKA_commMenu_supportMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet
