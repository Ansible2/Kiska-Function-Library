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
        PRE-INIT function
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_addDiaryEntry";


if (!hasInterface) exitWith {
    ["Was run on machine without interface, needs an interface"] call KISKA_fnc_log;
    nil
};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};

if (!canSuspend) exitWith {
    ["Must be run in scheduled",false] call KISKA_fnc_log;
    [] spawn KISKA_fnc_GCH_addDiaryEntry;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

[
    [
        "Group Manager GUI",
        "<execute expression='call KISKA_fnc_GCH_openDialog;'>Open Group Changer Dialog</execute>"
    ]
] call KISKA_fnc_addKiskaDiaryEntry;


nil
