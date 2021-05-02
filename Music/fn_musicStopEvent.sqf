/* ----------------------------------------------------------------------------
Function: KISKA_fnc_musicStopEvent

Description:
	The function that should be activated when music stops playing.

	It can also be manually triggered and a param is added to stop the music audio
	 by playing an empty track ("").

Parameters:
	0: _stopAudio <BOOL> - Play and empty track ("") to actually stop the audio

Returns:
	NOTHING

Examples:
    (begin example)
		[] call KISKA_fnc_musicStopEvent;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_musicStopEvent";

if (!hasInterface) exitWith {};

params [
	["_stopAudio",false,[true]]
];

if (_stopAudio) then {
	playMusic "";
};

["Music stopped",false] call KISKA_fnc_log;

missionNamespace setVariable ["KISKA_musicPlaying",false];
missionNamespace setVariable ["KISKA_currentTrack",""];
