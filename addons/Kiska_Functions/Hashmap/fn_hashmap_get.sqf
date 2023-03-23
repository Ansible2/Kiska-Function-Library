/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_get

Description:
    Gets a value from a hashmap but also supports objects and groups as keys.

    Ideally, not something that should be used if the map is not intended to
     also hold groups and objects as keys.

Parameters:
    0: _map <HASHMAP> - The map to get the value from
    1: _key <ANY> - The key to find in the map
    2: _default <ANY> - The value to return if the map does not contain the value

Returns:
    <ANY> - The saved value, default value, or nil if not found and no default provided

Examples:
    (begin example)
        private _value = [
            myMap,
            someObject,
            "Hello World"
        ] call KISKA_fnc_hashmap_get;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_get";

params [
    "_map",
    "_key",
    "_default"
];

_key = [_key] call KISKA_fnc_hashmap_getRealKey;

// while not in every case, there are some instances in which 
// a nil _default will throw an error if called.
// in an eventhandler seems to be one such case
// hence why it is sectioned off instead of always used
// as `_map getOrDefault [_key,nil];`
if !(isNil "_default") exitWith {
    _map getOrDefault [_key,_default];
};

_map get _key;
