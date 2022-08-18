/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playRandom3dSoundLoop

Description:


Parameters:
	0:  <> -

Returns:
	NOTHING

Examples:
    (begin example)
		[

		] call KISKA_fnc_playRandom3dSoundLoop;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playRandom3dSoundLoop";

params [
	["_sounds",[],[[]]]
];

// parse sounds into hashmap with configs


// takes an array of sounds
// sounds can be string (cfgSound classname) or an array [classname,duration of sound]
// sounds are ultimately evaluated into an array of [config of sound,duration of sound]
// update playound 3d to also accept configs and skip trying to find it

nil
