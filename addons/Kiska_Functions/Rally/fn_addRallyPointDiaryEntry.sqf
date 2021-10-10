/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addRallyPointDiaryEntry

Description:
	Adds a rally point diary entry to the local player. Pressing it enables the
	 player to drop a rally point if their group is registered as allowed to and
	 they are the leader of the group.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		PRE-INIT Function
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addRallyPointDiaryEntry";

#define RETURN_NIL nil

if (!hasInterface) exitWith {
	["Was run on machine without interface, needs an interface",false] call KISKA_fnc_log;
	RETURN_NIL
};

if (call KISKA_fnc_isMainMenu) exitWith {
	["Main menu detected, will not init",false] call KISKA_fnc_log;
	nil
};

if (!isMultiplayer) exitWith {
	["KISKA rally point system does not run in singlePlayer",false] call KISKA_fnc_log;
	RETURN_NIL
};

if (!canSuspend) exitWith {
	["Must be run in scheduled",false] call KISKA_fnc_log;
	[] spawn KISKA_fnc_addRallyPointDiaryEntry;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};


[
	[
		"Rally Point",
		"<execute expression='call KISKA_fnc_updateRespawnMarkerQuery'>Set Rally Point At Current Position</execute>"
	]
] call KISKA_fnc_addKiskaDiaryEntry;


RETURN_NIL
