#include "Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_removeFromPool

Description:
	Removes the provided index from the pool.

Parameters:
	0: _index <NUMBER> - The selected index

Returns:
	NOTHING

Examples:
    (begin example)
		[0] call KISKA_fnc_supportManager_removeFromPool;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_removeFromPool";

if (!hasInterface) exitWith {};

params ["_index"];

private _array = missionNamespace getVariable [TO_STRING(POOL_GVAR),[]];
if (_array isNotEqualTo []) then {
	_array deleteAt _index;
};


nil