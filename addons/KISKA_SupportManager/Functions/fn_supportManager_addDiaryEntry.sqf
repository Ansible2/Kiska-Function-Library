/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_addDiaryEntry

Description:
    Creates a diary entry in the map for the player to open the support Manager

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        POST-INIT function
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_addDiaryEntry";

if (!hasInterface) exitWith {
    ["Was run on machine without interface, needs an interface"] call KISKA_fnc_log;
    nil
};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

[
    [
        "Support Manager GUI",
        "<execute expression='call KISKA_fnc_supportManager_open;'>Open Support Manager</execute>"
    ]
] call KISKA_fnc_addKiskaDiaryEntry;


nil
