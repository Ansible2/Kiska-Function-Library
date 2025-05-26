/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_getMap

Description:
    Retrieves the hashmap that contains a players current supports.

Parameters:
    NONE

Returns:
    <HASHMAP> - The hashmap containing information about the player's supports.

Examples:
    (begin example)
        private _supportMap = call KISKA_fnc_supports_getMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_getMap";

[
    localNamespace,
    "KISKA_supports_playerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet
