#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_addToPool_global

Description:
	Adds an entry into the global trait manager pool.

Parameters:
	0: _entryToAdd <STRING or ARRAY> - The trait to add

Returns:
	NOTHING

Examples:
    (begin example)
		["medic"] call KISKA_fnc_traitManager_addToPool_global;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_addToPool_global";

params [
	["_entryToAdd","",[""]]
];

_entryToAdd = toUpperANSI _entryToAdd;

if (_entryToAdd isEqualTo "" OR {_entryToAdd in NUMBER_TRAITS}) exitWith {
	[[_entryToAdd," can't be added"],true] call KISKA_fnc_log;
	nil
};

// verify class is defined
private _config = [["KISKA_cfgTraits",_entryToAdd]] call KISKA_fnc_findConfigAny;
if (isNull _config) exitWith {
    [[_entryToAdd," is not defined in any KISKA_cfgTraits!"],true] call KISKA_fnc_log;
    nil
};


[_entryToAdd,true] remoteExec ["KISKA_fnc_traitManager_addToPool",0,true];


nil
