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
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_addDiaryEntry";


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
    [] spawn KISKA_fnc_traitManager_addDiaryEntry;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 3;
    false
};

[
    [
        "Trait Manager GUI",
        "<execute expression='call KISKA_fnc_traitManager_open;'>Open Trait Manager GUI</execute>"
    ]
] call KISKA_fnc_addKiskaDiaryEntry;


nil
