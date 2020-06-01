/* ----------------------------------------------------------------------------
Function: KISKA_fnc_lookHere

Description:
	Takes objects and sets their direction towards the nearest object or position within a set

Parameters:
	0: _objectsToRotate <OBJECT or ARRAY> - The objects to setDir on 
	1: _positionsToLookAt <OBJECT or ARRAY> - The positions or objects to search for nearest

Returns:
	BOOL

Examples:
    (begin example)

		[player,[[0,0,0]]] call KISKA_fnc_lookHere;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_objectsToRotate",[],[objNull,[]]],
	["_positionsToLookAt",[],[objNull,[]]]
];

if (_objectsToRotate isEqualTo [] OR {_objectsToRotate isEqualType objNull AND {isNull _objectsToRotate}}) exitWith {
	"[KISKA_fnc_lookAtNearest] _objectsToRotate is undefined" call BIS_fnc_error;
	false
};

if (_objectsToRotate isEqualtype objNull) then {
	_objectsToRotate = [_objectsToRotate];
};

_objectsToRotate apply {
	private _nearestPosition = [_positionsToLookAt,_x] call BIS_fnc_nearestPosition;

	_x setDir (_x getRelDir _nearestPosition);
	_x doWatch _nearestPosition;
};

true