/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_getVariableFromRealKey

Description:
    Translates a real key used by KISKA hashmaps for nullable types and namespaces
     back into the associated variable.

Parameters:
    0: _key <STRING> - The real key used to identify an object or group in a KISKA hashmap

Returns:
    <NAMESPACE, LOCATION, GROUP, OBJECT, TEAMMEMBER, TASK, CONTROL, DISPLAY, or NIL> - 
        The nullable or namespace that is associated with a given key. `NIL` if no 
        variable matches the given key.

Examples:
    (begin example)
        private _key = [someObject] call KISKA_fnc_hashmap_getRealKey;
        private _someObject = [
            _key
        ] call KISKA_fnc_hashmap_getVariableFromRealKey;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_getVariableFromRealKey";

params [
    ["_key","",[""]]
];


private _variableKeyMap = call KISKA_fnc_hashmap_getVariableKeyMap;
_variableKeyMap get _key
