/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stopRandom3dSoundLoop

Description:
    Stops a 3d sound loop created with KISKA_fnc_playRandom3dSoundLoop;

Parameters:
    0: _id <NUMBER> - The id returned from KISKA_fnc_playRandom3dSoundLoop

Returns:
    NOTHING

Examples:
    (begin example)
        [0] call KISKA_fnc_stopRandom3dSoundLoop;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stopRandom3dSoundLoop";

params [
    ["_id",-1,[123]]
];

if (_id < 0) exitWith {
    ["Invalid _id given!",true] call KISKA_fnc_log;
    nil
};

private _idAsString = str _id;
localNamespace setVariable [("KISKA_random3dSoundLoopIsPlaying_" + _idAsString), nil];
