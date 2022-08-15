/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stopBattleSound

Description:
	Stops battle sounds playing for the given id.

Parameters:
	0: _chatterId <OBJECT> - Where the sound is coming from

Returns:
	NOTHING

Examples:
    (begin example)
		[0] call KISKA_fnc_stopBattleSound;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stopBattleSound";

params [
    ["_id",-1,[123]]
];

if (_id < 0) exitWith {
    ["Invalid _id given!",true] call KISKA_fnc_log;
    nil
};

private _idAsString = str _id;
localNamespace setVariable [("KISKA_battleSoundIsPlaying_" + _idAsString), nil];
