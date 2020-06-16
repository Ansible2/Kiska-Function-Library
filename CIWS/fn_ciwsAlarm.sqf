/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciwsAlarm

Description:
	Sounds an alarm for the CIWS

Parameters:
	0: _turret : <OBJECT> - The CIWS turret

Returns:
	Nothing

Examples:
    (begin example)

		null = [turret1] spawn KISKA_fnc_ciwsAlarm;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!canSuspend) exitWith {
	"Must be run in scheduled envrionment" call BIS_fnc_error;
};

params [
	["_turret",objNull,[objNull]]
];

if (isNull _turret) exitWith {
	"_turret isNull" call BIS_fnc_error
};


// set turret to engaging targets
_turret setVariable ["KISKA_CIWS_allClear",false];
_turret setVariable ["KISKA_CIWS_alarmSounding",true];

// start the alarms
["KISKA_airRaidStart",_turret,1000,3] call KISKA_fnc_playSound3d;

// start Sirens
[_turret] spawn KISKA_fnc_ciwsSiren;

// wait to start looping airRaid so that sounds overlap some
sleep 6.4;

// start the air raid loop
waitUntil {
	// check if loop should end
	if (_turret getVariable "KISKA_CIWS_allClear") exitWith {
		["KISKA_airRaidEnd",_turret,1000,3] call KISKA_fnc_playSound3d;
		_turret setVariable ["KISKA_CIWS_alarmSounding",false];
		true
	};

	["KISKA_airRaidLoop",_turret,1000,3] call KISKA_fnc_playSound3d;
	sleep 10.8;
	false
};