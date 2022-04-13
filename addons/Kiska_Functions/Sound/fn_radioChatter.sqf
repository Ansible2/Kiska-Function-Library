/* ----------------------------------------------------------------------------
Function: KISKA_fnc_radioChatter

Description:
	Plays a random radio ambient at the specified position.
	This is a global effect now and should be executed on one machine, preferably the server

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
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_radioChatter";

if (!canSuspend) exitWith {
	["Must be run in a scheduled environement, exiting to scheduled...",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_radioChatter;
};

if (!isServer) then {
	["It is recommended to run this on the server"] call KISKA_fnc_log;
	nil
};

params [
	["_source",objNull,[objNull]],
	["_distance",20,[1]],
	["_volume",1,[1]]
];

if (isNull _source) exitWith {
	["Sound source isNull",true] call KISKA_fnc_log;
	nil
};

private _numberStr = str ([2,30] call BIS_fnc_randomInt);
private _radioSound = "KISKA_radioAmbient" + _numberStr;

[_radioSound,getPosASL _source,_distance,_volume] call KISKA_fnc_playSound3D;
sleep ((getNumber (configFile >> "CfgMusic" >> _radioSound >> "duration")) + random [1,5,10]);

[_source,_distance,_volume] spawn KISKA_fnc_radioChatter;


nil
