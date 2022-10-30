/* ----------------------------------------------------------------------------
Function: KISKA_fnc_idCounter

Description:
    For a given string id, return the latest "index" for that id.
    This increments the id by one each time it is called.

Parameters:
	0: _id <string> - The id to increment

Returns:
	<NUMBER> - the latest index of the given id

Examples:
    (begin example)
		private _latesIndexFor_myId = ["myId"] call KISKA_fnc_idCounter;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_idCounter";

params [
    ["_id","",[""]]
];

if (_id isEqualTo "") exitWith {
    ["Empty _id provided",true] call KISKA_fnc_log;
    -1
};

_id = toLowerANSI _id;

private _indexMap = localNamespace getVariable ["KISKA_indexMap",[]];
if (_indexMap isEqualTo []) then {
    _indexMap = createHashMap;
    localNamespace setVariable ["KISKA_indexMap",_indexMap];
};

private _latestIndex = _indexMap getOrDefault [_id, 0];
_indexMap set [_id,_latestIndex + 1];


_latestIndex
