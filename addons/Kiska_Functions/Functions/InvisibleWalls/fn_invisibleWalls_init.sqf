/* ----------------------------------------------------------------------------
Function: KISKA_fnc_invisibleWalls_init

Description:
    Automatically runs `KISKA_fnc_invisibleWalls_replaceCommon` at the start of a 
     mission if the `missionConfigFile >> "KiskaReplaceInvisibleWallsAtInit"` returns
     `true` with `KISKA_fnc_getConfigData`.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        POST-INIT Function
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_invisibleWalls_init";

private _doReplace = [
    missionConfigFile >> "KiskaReplaceInvisibleWallsAtInit",
    true,
    false
] call KISKA_fnc_getConfigData;

if !(_doReplace) exitWith {};

call KISKA_fnc_invisibleWalls_replaceCommon;


nil
