/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_addDiaryEntry

Description:
	Creates a diary entry in the map for the player to open the Group Manager

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
#define KISKA_DIARY "KISKA Systems"
#define SCRIPT_NAME "KISKA_fnc_GCH_addDiaryEntry"
scriptName SCRIPT_NAME;

if (!hasInterface) exitWith {
	["Was run on machine without interface, needs an interface",true] call KISKA_fnc_log;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

if !(player diarySubjectExists KISKA_DIARY) then {
	player createDiarySubject [KISKA_DIARY, KISKA_DIARY];
};

player createDiaryRecord [KISKA_DIARY, ["Group Manager GUI", 
	"<execute expression='openMap false; call KISKA_fnc_openGCHDialog;'>Open Group Changer Dialog</execute>"
]];