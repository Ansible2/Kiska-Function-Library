/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_deleteAt

Description:
	Deletes a key/value pair if it's in a hashmap, supports objects and groups as keys.

    Ideally, not something that should be used if the map is not intended to
     also hold groups and objects as keys.

Parameters:
	0: _map <HASHMAP> - The map to search in
	1: _key <ANY> - The key to delete

Returns:
	<ANY> - The deleted value, nil if not found

Examples:
    (begin example)
		private _value = [myMap,_key] call KISKA_fnc_hashmap_deleteAt;
    (end)

Author:
    Leopard20,
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_deleteAt";

params [
    "_map",
    "_key"
];

if !(_key isEqualType grpNull OR (_key isEqualType objNull)) exitWith {
    _map deleteAt _key

};

private "_value";
private _hash = hashValue _key;
private _collisionArray = _map getOrDefault [_hash, []];

if (_collisionArray isNotEqualTo [] AND _collisionArray isEqualType []) then {
    private "_rawKey";
    private _deleteIndex = -1;
    {
        _rawKey = _x select 0;
        if (!isNull _rawKey AND (_rawKey isEqualTo _key)) then {
            _value = _x select 1;
            _deleteIndex = _forEachIndex;
            break;
        };

    } forEach _collisionArray;

    if (_deleteIndex isNotEqualTo -1) then {
        _collisionArray deleteAt _deleteIndex
    };

};


_value
