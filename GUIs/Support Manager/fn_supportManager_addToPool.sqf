#include "Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_addToPool

Description:
	Adds an entry into the global support manager pool.

Parameters:
	0: _entryToAdd <STRING or ARRAY> - The support class or [support class,uses left]

Returns:
	NOTHING

Examples:
    (begin example)
		["someClass"] call KISKA_fnc_supportManager_addToPool;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_supportManager_addToPool";

params [
	["_entryToAdd","",["",[]]]
];

if (_entryToAdd isEqualTo "" OR {_entryToAdd isEqualTo []}) exitWith {
	["_entryToAdd is empty!",true] call KISKA_fnc_log;
	nil
};

// verify class is defined
private "_class";
if (_entryToAdd isEqualType []) then {
	_class = _entryToAdd select 0;
} else {
	_class = _entryToAdd;
};

private _config = [["CfgCommunicationMenu",_class]] call KISKA_fnc_findConfigAny;
if (isNull _config) exitWith {
	[[_class," is not defined in any CfgCommunicationMenu!"],true] call KISKA_fnc_log;
	nil
};


[TO_STRING(POOL_GVAR),_entryToAdd] remoteExecCall ["KISKA_fnc_pushBackToArray",(call CBA_fnc_players),true];


nil
