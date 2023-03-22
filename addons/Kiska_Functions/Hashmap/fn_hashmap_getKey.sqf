/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_get

Description:
    Returns the actual value used for a key when using KISKA hashmap functions.
	
	This really only applies to objects or groups as they will have a special string
	 used to identify them in the hashmap. Use this function to get the key of them
	 if you need to do multiple operations on a hashmap with the same object or group
	 and do not want the overhead of the functions.

Parameters:
    0: _key <ANY> - The key used with KISKA hashmap functions (such as object or group)

Returns:
    <ANY> - Whatever the key will be in a hashmap

Examples:
    (begin example)
        private _keyUsedInKiskaHashmap = [someObject] call KISKA_fnc_hashmap_getKey;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_getKey";

params ["_key"];

if (_key isEqualType grpNull OR (_key isEqualType objNull)) then {
    _key = (hashValue _key) + ([_key] call KISKA_fnc_netId);
};


_key
