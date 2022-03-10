/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_in

Description:
	Checks if a key exists in a hashmap, supports objects and groups as keys.

    Ideally, not something that should be used if the map is not intended to
     also hold groups and objects as keys.

Parameters:
	0: _map <HASHMAP> - The map to search in
	1: _key <ANY> - The key to find

Returns:
	<BOOL> - True if the key is found, false if not

Examples:
    (begin example)
		[myMap,_key] call KISKA_fnc_hashmap_in;
    (end)

Author:
    Leopard20,
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_in";

params [
    "_map",
    "_key"
];

if !(_key isEqualType grpNull OR (_key isEqualType objNull)) exitWith {
    _key in _map
};

private _hash = hashValue _key;
private _valueArray = _map getOrDefault [_hash,[],true];

private "_rawKey";
_valueArray apply {
    _rawKey = _x select 0;
    if (!isNull _rawKey AND (_rawKey isEqualTo _key)) then {
        _value = _x select 1;
        break;
    };

};
