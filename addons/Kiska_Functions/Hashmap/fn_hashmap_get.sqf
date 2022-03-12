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

if (_key isEqualType grpNull OR (_key isEqualType objNull)) then {
    _key = (hashValue _key) + ([_key] call KISKA_fnc_netId);
};

private "_value";
if (!isNil "_default") then {
    _value = _map getOrDefault [_key,_default];

} else {
    _value = _map get _key;

};


_value
