/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setDirRelative

Description:
	Takes objects and sets their direction towards the nearest object or position within a set

Parameters:
	0: _objectsToRotate <OBJECT or ARRAY> - The objects to setDir on 
	1: _positionsToLookAt <OBJECT or ARRAY> - The positions or objects to search for nearest

Returns:
	BOOL

Examples:
    (begin example)

		[player,[[0,0,0]]] call KISKA_fnc_setDirRelative;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_objectsToRotate",[],[objNull,[]]],
	["_positionsToLookAt",[],[objNull,[]]]
];

if (_objectsToRotate isEqualTo [] OR {_objectsTorRotate isEqualType objNull AND {isNull _objectsToRotate}}) exitWith {
	"[KISKA_fnc_lookAtNearest] _objectsToRotate is undefined" call BIS_fnc_error;
};

if ((_positionsToLookAt isEqualType [] AND {!(_positionsToLookAt isEqualTypeArray [objNull,[]])}) OR {_positionsToLookAt isEqualTo []}) exitWith {
	"[KISKA_fnc_lookAtNearest] _positionsToLookAt is configed improperly" call BIS_fnc_error;
};

_objectsToRotate apply {
	private _nearestPosition = [_positionsToLookAt,_x] call BIS_fnc_nearestPosition;

	_x setDir (_x getRelDir _nearestPosition);
};

true