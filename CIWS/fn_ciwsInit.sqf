/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciwsInit

Description:
	Fires a number of rounds from AAA piece at target with random disperstion values

Parameters:
	0: _turret : <OBJECT> - The CIWS turret
	1: _searchDistance : <NUMBER> - How far out will the CIWS be notified of a target
	2: _engageAboveAltitude : <NUMBER> - What altittiude (AGL) does the target need to be above to be engaged
	3: _searchInterval : <NUMBER> - Time between checks for targets in area
	4: _doNotFireBelowAngle : <NUMBER> - Below what angle should the turret NOT fire (keep it from firing at ground accidently)
	5: _pitchTolerance : <NUMBER> - if the turret's pitch is within this margin of degrees to the target, it can engage
	6: _rotationTolerance : <NUMBER> - if the turret's rotation is within this margin of degrees to the target, it can engage
	7: _soundAlarm : <BOOL> - Play air raid siren and sound alarm when incoming detected
	8: _engageTypes : <ARRAY> - This array decides what types of objects or entities should be engaged by the CIWS
								 these are formatted as an array or string inside, using an array allows the
								 decision to define a type as supported by nearEntities (which is much faster then the default nearObjects)
								 simply by setting it as ["myEntityType",true]

Returns:
	Nothing

Examples:
    (begin example)

		null = [turret,3000,100] spawn KISKA_fnc_ciwsInit;

    (end)

Author:
	DayZMedic,
	modified/optimized by Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define DEFAULT_ENGAGE_TYPES [["RocketBase",false],["MissileBase",false],["ShellBase",false],["R_230mm_HE",false]]

#define SCRIPT_NAME "KISKA_fnc_ciwsInit"
scriptName SCRIPT_NAME;

if (!canSuspend) exitWith {
	_this spawn KISKA_fnc_ciwsInit;
	[SCRIPT_NAME,"Was not run in scheduled; running in scheduled",false,true] call KISKA_fnc_log;
};

params [
	["_turret",objNull,[objNull]],
	["_searchDistance",3000,[123]],
	["_engageAboveAltitude",50,[123]],
	["_searchInterval",2,[123]],
	["_doNotFireBelowAngle",5,[123]],
	["_pitchTolerance",3,[123]],
	["_rotationTolerance",10,[123]],
	["_soundAlarm",true,[false]],
	["_engageTypes",DEFAULT_ENGAGE_TYPES,[]]
];

if (isNull _turret) exitWith {
	[SCRIPT_NAME,[_turret,"is a null object. Exiting..."],true,true] call KISKA_fnc_log;
};
if !(_turret isKindOf "AAA_System_01_base_F") exitWith {
	[SCRIPT_NAME,[typeOf _turret,"is not the proper type (AAA_System_01_base_F). Exiting..."],true,true] call KISKA_fnc_log;
};

_turret setVariable ["KISKA_runCIWS",true];

// make sure turret only fires when we tell it to
// possibly add this as a param in the future
//_turret setCombatMode "BLUE";

[SCRIPT_NAME,[_turret,"set KISKA_runCIWS to true"]] call KISKA_fnc_log;

private [
	"_targetDistance",
	"_turretPitchAngle",
	"_angleToTarget",
	"_currentPitchTolerance",
	"_turretVector",
	"_turretDir",
	"_relativeDir",
	"_currentRotTolerance",
	"_targetAlt",
	"_firedShots",
	"_turretPitchAngle",
	"_targetPos",
	"_targetBoom",
	"_targetIndex"
];	

private _incoming = [];
private _fn_updateIncomingList = {
	// nearestObjects and nearEntities do not work here
	[SCRIPT_NAME,[_turret,"is searching for incoming within",_searchDistance]] call KISKA_fnc_log;

	_incoming = [];

	_engageTypes apply {
		_x params [
			"_type",
			["_isEntity",false]
		];

		if (_isEntity) then {
			_incoming append (_turret nearEntities [_type,_searchDistance]);
		} else {
			_incoming append (_turret nearObjects [_type,_searchDistance]);
		};

	};

	[SCRIPT_NAME,[_turret,"found",_incoming]] call KISKA_fnc_log;

	_incoming
};

private _target = objNull;

private _fn_isNullTarget = {
	isNull _target
};

private _fn_checkIfStopAlarm = {
	[
		{
			params ["_turret","_searchDistance","_engageTypes"];
			private _incoming = [];

			_engageTypes apply {
				_x params [
					"_type",
					["_isEntity",false]
				];

				if (_isEntity) then {
					_incoming append (_turret nearEntities [_type,_searchDistance]);
				} else {
					_incoming append (_turret nearObjects [_type,_searchDistance]);
				};
			};	
			
			if (_incoming isEqualTo []) then {
				_turret setVariable ["KISKA_CIWS_allClear",true];
			};
		},
		[_turret,_searchDistance,_engageTypes],
		5
	] call CBA_fnc_waitAndExecute;
};

// turrets don't like to watch objects consistently, so we'll use their position instead for doWatch
private _fn_updateTargetPos = {
	_targetPos = getPosVisual _target;
};

private _fn_waitToFireOnTarget = {
	_turret enableAI "WEAPONAIM";

	waitUntil {
		if (call _fn_isNullTarget) exitWith {
			[SCRIPT_NAME,[_turret,"stopped waiting on null target"]] call KISKA_fnc_log;
			true
		};
		// keep turret rotating to target
		[SCRIPT_NAME,[_turret,"trying to get an angle on",_target]] call KISKA_fnc_log;
		call _fn_updateTargetPos;
		_turret lookAt _targetPos;
		
		//// turret pitch
		// get turrets pitch angle (0.6 offset is baked into source anim)
		_turretPitchAngle = abs ((deg (_turret animationSourcePhase "maingun")) + 0.6);
		// get the angle needed to target
		_angleToTarget = abs (acos ((_turret distance2D _target) / (_turret distance _target)));
		// get the difference between turrets current pitch and the targets actual angle
		_currentPitchTolerance = (selectMax [_turretPitchAngle,_angleToTarget]) - (selectMin [_turretPitchAngle,_angleToTarget]);
		[SCRIPT_NAME,["_turret:",_turret,"_turretPitchAngle:",_turretPitchAngle,"_angleToTarget:",_angleToTarget,"_currentPitchTolerance:",_currentPitchTolerance]] call KISKA_fnc_log;

		//// turret rotation
		// get turrets rotational angle
		_turretVector = _turret weaponDirection (currentWeapon _turret);
		_turretDir = (_turretVector select 0) atan2 (_turretVector select 1);
		_turretDir = [_turretDir] call CBA_fnc_simplifyAngle;
		// get relative rotational angle to the target
		_relativeDir = _turret getDir _target;				
		// get the degree between where the target is at relative to the turret position and its actual gun
		_currentRotTolerance = (_turretDir max _relativeDir) - (_turretDir min _relativeDir);
		[SCRIPT_NAME,["_turret:",_turret,"_turretVector:",_turretVector,"_turretDir:",_turretDir,"_relativeDir:",_relativeDir,"_currentRotTolerance:",_currentRotTolerance]] call KISKA_fnc_log;
		
		// get target alt
		call _fn_updateTargetPos;
		_targetAlt = _targetPos select 2;

		if (call _fn_isNullTarget) exitWith {
			[SCRIPT_NAME,[_turret,"stopped waiting on null target"]] call KISKA_fnc_log;
			true
		};

		if (
			(_currentPitchTolerance <= _pitchTolerance AND 
			{_currentRotTolerance <= _rotationTolerance} AND 
			{_targetALt >= _engageAboveAltitude}) OR 

			{(_turret distance _target) >= (_searchDistance * 0.75)}
		) 
		exitWith {
			[SCRIPT_NAME,[_turret,"got an angle on",_target]] call KISKA_fnc_log;
			true
		};

		sleep 0.25;
		[SCRIPT_NAME,[_turret,"sleep 0.25"]] call KISKA_fnc_log;

		false
	};
};

private _fn_whileTargetsIncoming = {
	[SCRIPT_NAME,[_turret,"found targets"]] call KISKA_fnc_log;
	
	// while there are still targets in the air; this was orginally a simple for loop, but the alarm sound requires the extra complication of
	/// searching for incoming projectiles constantly after the first is detected
	while {
		[SCRIPT_NAME,[_turret,"sleep 0.5, _fn_whileTargetsIncoming"]] call KISKA_fnc_log;
		sleep 0.5;	
		call _fn_updateIncomingList;
		// if projectiles are still incoming
		if !(_incoming isEqualTo []) then {true} else {false}
	} do {
		// check if sound alarm requested and that the alarm is not already sounding
		if (_soundAlarm AND {!(_turret getVariable ["KISKA_CIWS_alarmSounding",false])}) then {
			// sound alarm
			null = [_turret] spawn KISKA_fnc_ciwsAlarm;
		};
		
		[SCRIPT_NAME,[_turret,"searching through targets"]] call KISKA_fnc_log;
		_targetIndex = _incoming findIf {
			(isNull (_x getVariable ["KISKA_CIWS_engagedBy",objNull])) AND
			{(_x distance _turret) > 25}
		};
		
		if (_targetIndex != -1) then {
			_target = _incoming select _targetIndex;
			_targetDistance = _target distance _turret;

			[SCRIPT_NAME,[_turret,"found target",_target,"at",_targetDistance]] call KISKA_fnc_log;
			
			call _fn_waitToFireOnTarget

			call _fn_fireAtTarget

		} else {
			[SCRIPT_NAME,[_turret,"target,",_target,"did not meet params"]] call KISKA_fnc_log;
			//sleep 0.5;
		};
	};

};

private _fn_fireAtTarget = {
	if (!(isNull _target) AND {(_turret distance _target) <= _searchDistance}) then {
		[SCRIPT_NAME,[_turret,"got params met on",_target]] call KISKA_fnc_log;
		
		// track if unit actually got off shots
		_firedShots = false;
		private "_engagedBy";
		private _numberOfShots = random [50,100,150];
		[SCRIPT_NAME,["_numberOfShots is:",_numberOfShots]] call KISKA_fnc_log;

		private _shotMin = _numberOfShots / 3;
		[SCRIPT_NAME,["_shotMin is:",_shotMin]] call KISKA_fnc_log; 

		private _explodeAtShot = round (random [_shotMin,_shotMin * 2,_numberOfShots]);
		[SCRIPT_NAME,["_explodeAtShot is:",_explodeAtShot]] call KISKA_fnc_log; 

		private _didExplode = false;

		for "_i" from 1 to _numberOfShots do {

			if (isNull _target) exitWith {
				[SCRIPT_NAME,[_turret,"target became null"]] call KISKA_fnc_log;
			};

			_engagedBy = _target getVariable ["KISKA_CIWS_engagedBy",objNull];

			// check if target was engaged by another turret
			if (!(isNull _engagedBy) AND {!(_engagedBy isEqualTo _turret)}) exitWith {
				[SCRIPT_NAME,[_turret,"will not engage",_target,"; It's already being engaged by",_engagedBy]] call KISKA_fnc_log;
			};

			// keep watching target
			_turret lookAt _target;
			_turretPitchAngle = (deg (_turret animationSourcePhase "maingun")) + 0.6;
			
			// only fire above specified angle
			if (_turretPitchAngle >= _doNotFireBelowAngle) then {
				// ensure target is not reEngaged
				if (isNull _engagedBy) then {
					_target setVariable ["KISKA_CIWS_engagedBy",_turret];
				};

				// turret shoots 1 round
				_turret fireAtTarget [_target,currentWeapon _turret];
				
				// create explosion
				if (!_didExplode AND {_i >= _explodeAtShot}) then {
					[SCRIPT_NAME,"Reached explosion, updating target pos"] call KISKA_fnc_log; 
					call _fn_updateTargetPos;
					
					// delay explosion because bullets take time to reach their target
					null = [_turret,_targetPos] spawn {
						params ["_turret","_targetPos"];

						// bullet travels about 1m every 0.0005s
						private _sleep = (0.0005 * (_turret distance _targetPos));
						sleep _sleep;
						createVehicle ["HelicopterExploBig",_targetPos,[],0,"FLY"];
					};

					// stop target so it doesn't hit something 
					_target setVelocity [0,0,0];

					_didExplode = true;
				};

				// update if unit fired
				if (!_firedShots) then {
					_firedShots = true;
				};

				[SCRIPT_NAME,[_turret,"fired at",_target,"shot number",_i]] call KISKA_fnc_log;
			};

			sleep 0.01;
		};

		// reset lookAt
		_turret lookAt objNull;
		// sometimes the turret locks up in its aiming animations (becomes slow to aim)
		// this is used as a sort of reset
		_turret disableAI "WEAPONAIM";

		if (!(isNull _target) AND {_firedShots}) then {		
			triggerAmmo _target;
			
			if (alive _target) then {
				deleteVehicle _target;
			};

			[SCRIPT_NAME,[_turret,"destroyed target",_target]] call KISKA_fnc_log;
		};

	} else {
		[SCRIPT_NAME,[_turret,"target",_target,"did not meet params"]] call KISKA_fnc_log;
	};
};


while {alive _turret AND {_turret getVariable ["KISKA_runCIWS",true]}} do {
	// get incoming projectiles
	call _fn_updateIncomingList;
	
	// if projectiles are present then proceed, else sleep
	if !(_incoming isEqualTo []) then {
		[SCRIPT_NAME,[_turret,"found targets"]] call KISKA_fnc_log;
		
		call _fn_whileTargetsIncoming;

		// turn off alarm if used
		if (_soundAlarm) then {
			// used a wait and exec to create a new thread so that this could be evaluated independently
			// the goal is to reduce alarm sound overlap by keeping it going if the rounds are close together
			call _fn_checkIfStopAlarm
		};
		
	} else {
		[SCRIPT_NAME,[_turret,"sleep 0.5, the target did not meet params"]] call KISKA_fnc_log;
		sleep _searchInterval;
	};
};