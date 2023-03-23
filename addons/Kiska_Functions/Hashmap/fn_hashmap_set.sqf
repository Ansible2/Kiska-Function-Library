/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_set

Description:
    Sets a key/value pair in a hashmap but also supports objects and groups as keys.

    Ideally, not something that should be used if the map is not intended to
     also hold groups and objects as keys.

Parameters:
    0: _map <HASHMAP> - The map to insert in to
    1: _key <ANY> - The key to associate with the value
    2: _value <ANY> - The value to associate witht the key
    3: _insertOnly <BOOL> - When `true`, if the key already exists in the hashmap, 
     the value will not be overwritten

Returns:
    <BOOL> - False if key is new, true if overwriting

Examples:
    (begin example)
        private _inserted = [
            myMap,
            someObject,
            "Hello World"
        ] call KISKA_fnc_hashmap_set;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_set";

params [
    "_map",
    "_key",
    "_value",
    ["_insertOnly",false,[true]]
];

_key = [_key] call KISKA_fnc_hashmap_getRealKey;
_map set [_key,_value,_insertOnly];
