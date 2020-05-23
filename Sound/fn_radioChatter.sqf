/* ----------------------------------------------------------------------------
Function: KISKA_fnc_radioChatter

Description:
	Plays a random radio ambient at the specified position.
	This is a local effect and must be run on all systems that desire to hear it.

Parameters:
	0: _source <OBJECT> - Where the sound is coming from
	1: _distance <NUMBER> - Distance at which the sound can be heard
	2: _volume <NUMBER> - Volume of the sound between 1-5

Returns:
	NOTHING

Examples:
    (begin example)

		[player,20] spawn KISKA_fnc_radioChatter;

    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!canSuspend) exitWith {
	"Must be run in a scheduled environement" call BIS_fnc_error;
};

params [
	["_source",objNull,[objNull,[]]],
	["_distance",20,[1]],
	["_volume",1,[1]]
];

if (isNull _source) exitWith {
	"Sound source isNull" call BIS_fnc_error;
};

private _numberStr = str ([2,30] call BIS_fnc_randomInt);

private _radioSound = "KISKA_radioAmbient" + _numberStr;

[_radioSound,getPosASL _source,_distance,_volume] call KISKA_fnc_playSound3D;

sleep ((getNumber (configFile >> "CfgMusic" >> _radioSound >> "duration")) + random [1,5,10]);

[_source,_distance,_volume] spawn KISKA_fnc_radioChatter;