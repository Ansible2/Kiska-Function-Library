#include "Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_addToPool

Description:
	Adds an entry into the global trait manager pool.

Parameters:
	0: _entryToAdd <STRING or ARRAY> - The trait to add

Returns:
	<BOOL> - True if added, false if not

Examples:
    (begin example)
		["medic"] call KISKA_fnc_traitManager_addToPool;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_addToPool";

#define NUMBER_TRAITS ["LOADCOEF","AUDIBLECOEF","CAMOUFLAGECOEF"]

params [
	["_entryToAdd","",[""]]
];

_entryToAdd = toUpperANSI _entryToAdd;

if (_entryToAdd isEqualTo "" OR {_entryToAdd in NUMBER_TRAITS}) exitWith {
	[[_entryToAdd," can't be added"],true] call KISKA_fnc_log;
	false
};


[TO_STRING(POOL_GVAR),_entryToAdd] remoteExecCall ["KISKA_fnc_pushBackToArray_interface",0,true];


true
