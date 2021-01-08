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
		Post Init Function
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define KISKA_DIARY "KISKA Systems"
#define SCRIPT_NAME "KISKA_fnc_addRallyPointDiaryEntry"
scriptName SCRIPT_NAME;

if (!hasInterface) exitWith {
	[SCRIPT_NAME,"Was run on machine without interface, needs an interface",false,true,true] call KISKA_fnc_log;
};

if (!isMultiplayer) exitWith {
	[SCRIPT_NAME,"KISKA rally point system does not run in singlePlayer",false,true,true] call KISKA_fnc_log;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

if !(player diarySubjectExists KISKA_DIARY) then {
	player createDiarySubject [KISKA_DIARY, KISKA_DIARY];
};

player createDiaryRecord [KISKA_DIARY, ["Rally Point", 
	"<execute expression='call KISKA_fnc_updateRespawnMarkerQuery'>Set Rally Point At Current Position</execute>"
]];