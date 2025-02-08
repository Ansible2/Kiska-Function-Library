/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getPlayerSupportMap

Description:
    Retrieves the hashmap that contains a players current supports.

Parameters:
    NONE

Returns:
    <HASHMAP> - The hashmap containing information about the player's supports.

Examples:
    (begin example)
        private _supportMap = call KISKA_fnc_getPlayerSupportMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getPlayerSupportMap";

private _supportMap = localNamespace getVariable "KISKA_playersSupportMap";
if (isNil "_supportMap") then {
    _supportMap = createHashMap;
    localNamespace setVariable ["KISKA_playerSupportMap",_supportMap];
};


_supportMap
