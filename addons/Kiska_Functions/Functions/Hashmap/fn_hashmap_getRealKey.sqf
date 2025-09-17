/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_getRealKey

Description:
    Returns the actual value used for a key when using KISKA hashmap functions.
    
    This really only applies to nullable types and namespaces such as objects 
     or groups as they will have a special string used to identify them in the 
     hashmap. Use this function to get the key of them if you need to do multiple
     operations on a hashmap with the same vanilla unsupported type and do not 
     want the overhead of the functions.

Parameters:
    0: _key <ANY> - The key used with KISKA hashmap functions (such as object or group)

Returns:
    <ANY> - Whatever the key will be in a hashmap

Examples:
    (begin example)
        private _keyUsedInKiskaHashmap = [someObject] call KISKA_fnc_hashmap_getRealKey;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_getRealKey";

params ["_key"];

if !(
    _key isEqualTypeAny [
        grpNull,
        objNull,
        locationNull,
        controlNull,
        displayNull,
        taskNull,
        teamMemberNull,
        localNamespace
    ]
) exitWith { _key };

private _keyInNamespace = _key getVariable "KISKA_hashmap_realKey";
if !(isNil "_keyInNamespace") exitWith { _keyInNamespace };


_keyInNamespace = "KISKA_hashmap_realKey" call KISKA_fnc_generateUniqueId;
_key setVariable ["KISKA_hashmap_realKey",_keyInNamespace];
private _variableKeyMap = call KISKA_fnc_hashmap_getVariableKeyMap;
_variableKeyMap set [_keyInNamespace,_key];


_keyInNamespace
