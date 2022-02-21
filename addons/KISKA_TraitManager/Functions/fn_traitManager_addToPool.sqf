#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_addToPool

Description:
	Adds an entry into the local trait manager pool.

Parameters:
	0: _entryToAdd <STRING> - The trait to add
	1: _bypassChecks <BOOL> - Decides whether or not to perform checks on _entryToAdd for errors

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
	["_entryToAdd","",[""]],
	["_bypassChecks",false]
];

private _exit = false;
if !(_bypassChecks) then {
	if (_entryToAdd isEqualTo "") exitWith {
		["_entryToAdd is empty string!",true] call KISKA_fnc_log;
		_exit = true;
	};

	// verify class is defined
	private _config = [["KISKA_cfgTraits",_entryToAdd]] call KISKA_fnc_findConfigAny;
	if (isNull _config) exitWith {
		[[_entryToAdd," is not defined in any KISKA_cfgTraits!"],true] call KISKA_fnc_log;
		_exit = true;
	};
};

if (_exit) exitWith {};


private _traitPoolArray = GET_TM_POOL;
_traitPoolArray pushBack _entryToAdd;
if (isNil TM_POOL_VAR_STR) then {
	missionNamespace setVariable [TM_POOL_VAR_STR,_traitPoolArray];
};

call KISKA_fnc_traitManager_updateCurrentList;
call KISKA_fnc_traitManager_updatePoolList;


nil
