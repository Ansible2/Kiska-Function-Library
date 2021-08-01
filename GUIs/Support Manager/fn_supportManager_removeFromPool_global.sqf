/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_removeFromPool_global

Description:
	Removes the provided index from the support pool with GLOBAl EFFECT.

Parameters:
	0: _index <NUMBER> - The selected index

Returns:
	NOTHING

Examples:
    (begin example)
		[0] call KISKA_fnc_supportManager_removeFromPool_global;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_removeFromPool_global";

params ["_index"];

[_index] remoteExec ["KISKA_fnc_supportManager_removeFromPool",0,true];


nil
