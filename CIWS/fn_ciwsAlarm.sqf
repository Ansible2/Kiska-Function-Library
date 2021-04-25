/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciwsAlarm

Description:
	Sounds an alarm for the CIWS

Parameters:
	0: _turret : <OBJECT> - The CIWS turret

Returns:
	NOTHING

Examples:
    (begin example)
		[turret1] spawn KISKA_fnc_ciwsAlarm;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ciwsAlarm";

#define RETURN_NIL nil
#define WAIT_FOR_AIRRAIDSTART 6.4
#define WAIT_TO_LOOP_SOUND 10.8
#define ALARM_DISTANCE 1000
#define ALARM_VOLUME 3

if (!canSuspend) exitWith {
	["Was not run in scheduled; running in scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_ciwsAlarm;
};

params [
	["_turret",objNull,[objNull]]
];

if (isNull _turret) exitWith {
	[[_turret," is a null object. Exiting..."],true] call KISKA_fnc_log;
	RETURN_NIL
};

if (_turret getVariable ["KISKA_CIWS_alarmSounding",false]) exitWith {
	[[_turret," already has its alarm sounding"],true] call KISKA_fnc_log;
	RETURN_NIL
};


// set turret to engaging targets
_turret setVariable ["KISKA_CIWS_allClear",false];
_turret setVariable ["KISKA_CIWS_alarmSounding",true];

// start the alarms
["KISKA_airRaidStart",_turret,ALARM_DISTANCE,ALARM_VOLUME] call KISKA_fnc_playSound3d;

// start Sirens
[_turret] spawn KISKA_fnc_ciwsSiren;

// To make the sounds appear to be synched, wait a bit to start the loop audio
sleep WAIT_FOR_AIRRAIDSTART;

// start the air raid loop
waitUntil {
	// check if loop should end and play audio if it should
	if (_turret getVariable "KISKA_CIWS_allClear") exitWith {
		["KISKA_airRaidEnd",_turret,1000,3] call KISKA_fnc_playSound3d;
		_turret setVariable ["KISKA_CIWS_alarmSounding",false];
		true
	};

	// play looped audio again
	["KISKA_airRaidLoop",_turret,1000,3] call KISKA_fnc_playSound3d;
	// sound should wait to loop back to end audio or loop sound
	sleep WAIT_TO_LOOP_SOUND;
	false
};


RETURN_NIL
