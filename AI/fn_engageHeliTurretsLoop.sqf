/* ----------------------------------------------------------------------------
Function: KISKA_fnc_engageHeliTurretsLoop

Description:
	Sets up a helicopter's turrets to be able to properly engage enemies without
     without the pilot going crazy. Constantly scans

Parameters:
	0: _heli : <OBJECT or ARRAY> - The helicopter to set up or its crew
	1: _radius : <NUMBER> - The size of the radius to patrol around
	2: _aircraftType : <STRING> - The class of the helicopter to spawn
	3: _timeOnStation : <NUMBER> - How long will the aircraft be supporting
	4: _supportSpeedLimit : <NUMBER> - The max speed the aircraft can fly while in the support radius
	5: _flyinHeight : <NUMBER> - The altittude the aircraft flys at
	6: _approachBearing : <NUMBER> - The bearing from which the aircraft will approach from (if below 0, it will be random)
	7: _side : <SIDE> - The side of the created helicopter

Returns:
	ARRAY - The vehicle info
		0: <OBJECT> - The vehicle created
		1: <ARRAY> - The vehicle crew
		2: <GROUP> - The group the crew is a part of

Examples:
    (begin example)
		[
			player,
			250,
			"B_Heli_Attack_01_dynamicLoadout_F"
		] call KISKA_fnc_helicopterGunner;
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_engageHeliTurretsLoop";

#define MIN_SLEEP_TIME 0.01
#define EXIT_VAR_STR "KISKA_heliTurrets_endLoop"
#define SLEEP_TIME_VAR_STR "KISKA_heliTurrets_sleepTime"
#define REVEAL_ACC_VAR_STR "KISKA_heliTurrets_revealAccuracy"
#define DETECT_RADIUS_VAR_STR "KISKA_heliTurrets_detectionRadius"

if (!canSuspend) exitWith {
    ["Needs to be run in scheduled! Exiting to scheduled...",true] call KISKA_fnc_log;
    _this spawn KISKA_fnc_engageHeliTurretsLoop;
};


params [
    ["_heli",objNull,[objNull]],
    ["_sleepTime",5,[123]],
    ["_revealAccuracy",4,[123]],
    ["_detectionRadius",250,[123]],
    ["_skill",1,[123]],
    ["_makeInvulnerable",false,[true]]
];


if (isNull _heli) exitWith {
    ["A null object was passed",true] call KISKA_fnc_log;
    nil
};


/* ----------------------------------------------------------------------------
	verify vehicle is compatible
---------------------------------------------------------------------------- */
private _aircraftType = typeOf _heli;
private _turretsWithWeapons = [_aircraftType] call KISKA_fnc_classTurretsWithGuns;

// go to default aircraft type if no suitable turrets are found
if (_turretsWithWeapons isEqualTo []) exitWith {
	[[_aircraftType," does not have properly configured turrets!"],true] call KISKA_fnc_log;
    nil
};



/* ----------------------------------------------------------------------------
	Prepare AI
---------------------------------------------------------------------------- */
private _turretUnits = [];
private _turretSeperated = false;
private _vehicleCrew = crew _heli;

_vehicleCrew apply {
    if (_makeInvulnerable) then {
       _x allowDamage false;
    };
	_x setSkill _skill;

    _x disableAI "SUPPRESSION";
	_x disableAI "RADIOPROTOCOL";

	// give turrets their own groups so that they can engage targets at will
	if ((_heli unitTurret _x) in _turretsWithWeapons) then {
	/*
		About seperating one turret...
		My testing has revealed that in order to have both turrets on a helicopter (if it has two)
		 engaging targets simultaneously, one needs to be in a seperate group from the pilot, and one
		 needs to be grouped with the pilot.
	*/
		if !(_turretSeperated) then {
			_turretSeperated = true;
			private _group = createGroup _side;
			[_x] joinSilent _group;
			_group setBehaviour "COMBAT";
			_group setCombatMode "RED";
		};
		_turretUnits pushBack _x;
	} else { // disable targeting for the other crew
		_x disableAI "AUTOCOMBAT";
		_x disableAI "TARGET";
		//_x disableAI "AUTOTARGET";
		_x disableAI "FSM";
	};
};

// keep the pilots from freaking out under fire
private _pilotsGroup = group (currentPilot _heli);
_pilotsGroup setBehaviour "CARELESS"; // Only careless group will follow speed limit
// the pilot group's combat mode MUST be a fire-at-will version as it adjusts it for the entire vehicle
_pilotsGroup setCombatMode "RED";



/* ----------------------------------------------------------------------------
	Loop
---------------------------------------------------------------------------- */
private _fn_getTargets = {
	(_heli nearEntities [["MAN","CAR","TANK"],(_heli getVariable [DETECT_RADIUS_VAR_STR, _detectionRadius])]) select {
		!(isAgent teamMember _x) AND
		{[side _x, _side] call BIS_fnc_sideIsEnemy}
	};
};


if (_sleepTime < MIN_SLEEP_TIME) then {
    _sleepTime = MIN_SLEEP_TIME;
};


_heli setVariable [EXIT_VAR_STR,false];
_heli setVariable [DETECT_RADIUS_VAR_STR, _detectionRadius];
_heli setVariable [SLEEP_TIME_VAR_STR, _sleepTime];
_heli setVariable [REVEAL_ACC_VAR_STR, _revealAccuracy];


private _targetsInArea = [];
// using waituntil to avoid running more then once a frame
waitUntil {
    if (isNull _heli OR (_heli getVariable [EXIT_VAR_STR,false])) exitWith {};

    _targetsInArea = call _fn_getTargets;
    if (_targetsInArea isNotEqualTo []) then {

    	_targetsInArea apply {
    		_currentTarget = _x;

    		_turretUnits apply {
                if !(isNull _x) then {
		            _x reveal [_currentTarget,(_heli getVariable [REVEAL_ACC_VAR_STR, _revealAccuracy])];
                };
    		};

    	};

    };

    sleep (_heli getVariable [SLEEP_TIME_VAR_STR, _sleepTime]);
};


nil
