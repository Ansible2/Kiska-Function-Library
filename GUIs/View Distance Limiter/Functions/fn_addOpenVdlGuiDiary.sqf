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
		PRE-INIT function
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addOpenVdlGuiDiary";

if (!hasInterface) exitWith {};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};

if (!canSuspend) exitWith {
	["Must be run in scheduled",false] call KISKA_fnc_log;
	[] spawn KISKA_fnc_addOpenVdlGuiDiary;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

[
	[
		"View Distance Limiter",
		"<execute expression='openMap false; call KISKA_fnc_openVdlDialog;'>OPEN VDL DIALOG</execute>"
	]
] call KISKA_fnc_addKiskaDiaryEntry;


nil
