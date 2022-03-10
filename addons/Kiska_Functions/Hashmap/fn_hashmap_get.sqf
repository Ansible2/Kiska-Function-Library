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
    3: _returnKeyValuePair <BOOL> - If the key is an object or group, true will
            return the array key/value pair

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
    Leopard20,
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_get";

params [
    "_map",
    "_key",
    "_default",
    ["_returnKeyValuePair",false,[true]]
];

private "_value";
if !(_key isEqualType grpNull OR (_key isEqualType objNull)) then {
    if (!isNil "_default") then {
        _value = _map getOrDefault [_key,_default];

    } else {
        _value = _map get _key;

    };

} else { // if key object or group
    private _hash = hashValue _key;
    private _valueArray = _map getOrDefault [_hash,[]];

    private "_rawKey";
    _valueArray apply {
        _rawKey = _x select 0;
        if (!isNull _rawKey AND (_rawKey isEqualTo _key)) then {
            if (_returnKeyValuePair) then {
                _value = _x;

            } else {
                _value = _x select 1;

            };

            break;
        };

    };

    if (isNil "_value" AND (!isNil "_default")) then {
        _value = _default;
    };

};


_value
