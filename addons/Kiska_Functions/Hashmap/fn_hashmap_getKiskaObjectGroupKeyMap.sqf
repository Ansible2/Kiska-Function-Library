/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_getObjectOrGroupFromRealKey

Description:
    Retrieves the global hashmap used to associate a given real key with either a
	 group or object with KISKA hashmap functions.

Parameters:
    NONE

Returns:
    <HASHMAP> - The hashmap used for finding the given object or group from
	 a real key used in a KISKA hashmap

Examples:
    (begin example)
        private _kiskaObjectOrGroupKeyHashMap = call KISKA_fnc_hashmap_getKiskaObjectGroupKeyMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_getKiskaObjectGroupKeyMap";

private _objectGroupKeyMap = localNamespace getVariable "KISKA_hashmapKeyMap";
if !(isNil "_objectGroupKeyMap") exitWith {_objectGroupKeyMap};

_objectGroupKeyMap = createHashMap;
localNamespace setVariable ["KISKA_hashmapKeyMap",_objectGroupKeyMap];


_objectGroupKeyMap
