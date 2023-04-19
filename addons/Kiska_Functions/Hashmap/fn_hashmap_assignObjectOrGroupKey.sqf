/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_assignObjectOrGroupKey

Description:
    Provides a unique hashmap key for a given object or group.

	The key can be reverse looked up for the object or group with 
	 KISKA_fnc_hashmap_getObjectOrGroupFromRealKey.

Parameters:
    0: _objectOrGroup <OBJECT or GROUP> - The object or group to assign a key to

Returns:
    <STRING> - The string key used to uniquely identify the given object or group

Examples:
    (begin example)
        private _associatedKey = [
			someObject
		] call KISKA_fnc_hashmap_assignObjectOrGroupKey;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_assignObjectOrGroupKey";

params [
	["_objectOrGroup",objNull,[objNull,grpNull]]
];


private _keyInNamespace = _objectOrGroup getVariable "KISKA_hashmap_key";
if !(isNil "_keyInNamespace") exitWith { _keyInNamespace };

private _key = (hashValue _objectOrGroup) + ([_objectOrGroup] call KISKA_fnc_netId);
_objectOrGroup setVariable ["KISKA_hashmap_key",_key];

private _objectGroupKeyMap = call KISKA_fnc_hashmap_getKiskaObjectGroupKeyMap;
_objectGroupKeyMap set [_key,_objectOrGroup];
        
_objectOrGroup addEventHandler ["Deleted",{
	params ["_objectOrGroup"];

	private _objectGroupKeyMap = [] call KISKA_fnc_hashmap_getKiskaObjectGroupKeyMap;
	private _key = [_objectOrGroup] call KISKA_fnc_hashmap_getKeyFromObjectOrGroup;
	_objectGroupKeyMap deleteAt _key;
}];


_key
