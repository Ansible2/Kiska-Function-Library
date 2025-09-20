/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_getVariableKeyMap

Description:
    Retrieves the global hashmap used to associate a given real key with either a
     group or object with KISKA hashmap functions.

Parameters:
    NONE

Returns:
    <HASHMAP> - The hashmap used for finding the given nullable type or namespace from
     a real key used in a KISKA hashmap.

Examples:
    (begin example)
        private _variableKeyMap = call KISKA_fnc_hashmap_getVariableKeyMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_getVariableKeyMap";

private _variableKeyMap = localNamespace getVariable "KISKA_hashmap_variableKeyMap";
if !(isNil "_variableKeyMap") exitWith { _variableKeyMap };

_variableKeyMap = createHashMap;
localNamespace setVariable ["KISKA_hashmap_variableKeyMap",_variableKeyMap];


_variableKeyMap
