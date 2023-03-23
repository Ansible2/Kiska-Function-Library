/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_getObjectOrGroupFromRealKey

Description:
    Translates a real key used be KISKA hashmaps for groups and objects back into
	 the associated group or object.

Parameters:
    0: _key <STRING> - The real key used to identify an object or group in a KISKA hashmap

Returns:
    <OBJECT, GROUP, or NIL> - The object or group that is associated with a given key.
	 `NIL` if no object or group matches the given key.

Examples:
    (begin example)
		private _key = [someObject] call KISKA_fnc_hashmap_getRealKey;
        private _someObject = [
			_key
		] call KISKA_fnc_hashmap_getObjectOrGroupFromRealKey;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_getObjectOrGroupFromRealKey";

params [
	["_key","",[""]]
];

private _objectGroupKeyMap = [] call KISKA_fnc_hashmap_getKiskaObjectGroupKeyMap;


_objectGroupKeyMap get _key
