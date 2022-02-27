#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_addToPool

Description:
	Adds an entry into the local trait manager pool.

Parameters:
	0: _entryToAdd <STRING> - The trait to add

Returns:
	NOTHING

Examples:
    (begin example)
		["medic"] call KISKA_fnc_traitManager_addToPool;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_addToPool";

if !(hasInterface) exitWith {};

params [
	["_entryToAdd","",[""]]
];

if (_entryToAdd isEqualTo "") exitWith {
	["_entryToAdd is empty string!",true] call KISKA_fnc_log;
	nil
};


private _traitPoolArray = GET_TM_POOL;
_traitPoolArray pushBack _entryToAdd;
if (isNil TM_POOL_VAR_STR) then {
	missionNamespace setVariable [TM_POOL_VAR_STR,_traitPoolArray];
};

call KISKA_fnc_traitManager_updateCurrentList;
call KISKA_fnc_traitManager_updatePoolList;


nil
