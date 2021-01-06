/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addOpenVdlGuiDiary

Description:
	Creates a diary entry to open the VDL dialog.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)

		Postinit function

    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define KISKA_DIARY "KISKA Systems"

if (!hasInterface) exitWith {};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

if !(player diarySubjectExists KISKA_DIARY) then {
	player createDiarySubject [KISKA_DIARY, KISKA_DIARY];
};

player createDiaryRecord [KISKA_DIARY, ["View Distance Limiter", 
	"<execute expression='openMap false; call KISKA_fnc_openVdlDialog;'>OPEN VDL DIALOG</execute>"
]];