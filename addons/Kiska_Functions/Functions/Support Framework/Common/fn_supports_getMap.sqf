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

private _map = localNamespace getVariable "KISKA_supports_playerMap";
if !(isNil "_map") exitWith { _map };

_map = createHashMap;
localNamespace setVariable ["KISKA_supports_playerMap",_map];


_map
