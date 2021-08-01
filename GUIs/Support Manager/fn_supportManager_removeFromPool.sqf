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
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_removeFromPool";

if (!hasInterface) exitWith {};

params ["_index"];

private _array = GET_SM_POOL;
if (_array isNotEqualTo []) then {
	_array deleteAt _index;
};

call KISKA_fnc_supportManager_updateCurrentList;
call KISKA_fnc_supportManager_updatePoolList;

nil
