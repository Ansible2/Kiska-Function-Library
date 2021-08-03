/* ----------------------------------------------------------------------------
Function: KISKA_fnc_isMusicPlaying

Description:
	Returns whether or not music is currently playing

Parameters:
	NONE

Returns:
	<BOOL> - false if nothing is playing, true if something is

Examples:
    (begin example)

		_isSomethingPlaying = call KISKA_fnc_isMusicPlaying;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_isMusicPlaying";

missionNameSpace getVariable ["KISKA_musicPlaying",false];
