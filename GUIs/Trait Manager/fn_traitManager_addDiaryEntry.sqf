/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_addDiaryEntry

Description:
	Creates a diary entry in the map for the player to open the trait Manager.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        POST-INIT function
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define RETURN_NIL nil
scriptName "KISKA_fnc_traitManager_addDiaryEntry";

if (!hasInterface) exitWith {
	["Was run on machine without interface, needs an interface"] call KISKA_fnc_log;
	RETURN_NIL
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

[
	[
		"Trait Manager GUI",
		"<execute expression='openMap false; call KISKA_fnc_traitManager_openDialog;'>Open Trait Manager GUI</execute>"
	]
] call KISKA_fnc_addKiskaDiaryEntry;


RETURN_NIL
