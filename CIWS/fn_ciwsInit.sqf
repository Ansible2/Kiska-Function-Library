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
		[turret,3000,100] spawn KISKA_fnc_ciwsInit;
    (end)

Author:
	DayZMedic,
	modified/optimized by Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ciwsInit";

#define DEFAULT_ENGAGE_TYPES [["RocketBase",false],["MissileBase",false],["ShellBase",false],["R_230mm_HE",false]]
#define RETURN_NIL nil
#define NUMBER_OF_MAGS 3
#define EXPLOSION_DELAY_CONST 0.0005
#define TURRET_WEAPON "Gatling_30mm_Plane_CAS_01_F"
#define TURRET_MAGAZINE "1000Rnd_Gatling_30mm_Plane_CAS_01_F"

if (!canSuspend) exitWith {
	["Was not run in scheduled; running in scheduled...",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_ciwsInit;
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
	[[_turret," is a null object. Exiting..."],true] call KISKA_fnc_log;
	RETURN_NIL
};
if !(_turret isKindOf "AAA_System_01_base_F") exitWith {
	[[typeOf _turret," is not the proper type (AAA_System_01_base_F). Exiting..."],true] call KISKA_fnc_log;
	RETURN_NIL
};

// disable HC transfer
[group _turret,false] call KISKA_fnc_ACEX_setHCTransfer;


// give the turret the cool red tracer gatling for more authenticity
_turret addWeaponTurret [TURRET_WEAPON, [0]];
for "_i" from 1 to NUMBER_OF_MAGS do {
	_turret addMagazineTurret [TURRET_MAGAZINE,[0],1000];
};
_turret selectWeaponTurret [TURRET_WEAPON,[0]];

private _engagedTargetsHash = createHashMap;
missionNamespace setVariable ["KISKA_CIWS_engagedTargetsHash",_engagedTargetsHash];

_turret setVariable ["KISKA_runCIWS",true];

// make sure turret only fires when we tell it to
// possibly add this as a param in the future
//_turret setCombatMode "BLUE";

[[_turret," set KISKA_runCIWS to true"],false] call KISKA_fnc_log;

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
	"_targetIndex",
	"_targetNetId"
];

private _incoming = [];
private _fn_updateIncomingList = {
	// nearestObjects and nearEntities do not work here
	[[_turret," is searching for incoming within ",_searchDistance],false] call KISKA_fnc_log;

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

	[[_turret," found ",_incoming],false] call KISKA_fnc_log;

	_incoming
};

private _target = objNull;

private _fn_isNullTarget = {
	isNull _target
};

// used a wait and exec to create a new thread so that this could be evaluated independently
// the goal is to reduce alarm sound overlap by keeping it going if the rounds are close together
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
			[[_turret," stopped waiting on null target #1"],false] call KISKA_fnc_log;
			true
		};
		// keep turret rotating to target
		[[_turret," trying to get an angle on ",_target],false] call KISKA_fnc_log;

// why?
/*
		if (call _fn_isNullTarget) exitWith {
			[[_turret," stopped waiting on null target #1"],false] call KISKA_fnc_log;
			true
		};
*/
		call _fn_updateTargetPos;
		_turret lookAt _targetPos;

		//// turret pitch
		// get turrets pitch angle (0.6 offset is baked into source anim)
		_turretPitchAngle = abs ((deg (_turret animationSourcePhase "maingun")) + 0.6);
		// get the angle needed to target
		_angleToTarget = abs (acos ((_turret distance2D _target) / (_turret distance _target)));
		// get the difference between turrets current pitch and the targets actual angle
		_currentPitchTolerance = (selectMax [_turretPitchAngle,_angleToTarget]) - (selectMin [_turretPitchAngle,_angleToTarget]);
		[["_turret: ",_turret," _turretPitchAngle: ",_turretPitchAngle," _angleToTarget: ",_angleToTarget," _currentPitchTolerance: ",_currentPitchTolerance],false] call KISKA_fnc_log;

		//// turret rotation
		// get turrets rotational angle
		_turretVector = _turret weaponDirection (currentWeapon _turret);
		_turretDir = (_turretVector select 0) atan2 (_turretVector select 1);
		_turretDir = [_turretDir] call CBA_fnc_simplifyAngle;
		// get relative rotational angle to the target
		_relativeDir = _turret getDir _target;
		// get the degree between where the target is at relative to the turret position and its actual gun
		_currentRotTolerance = (_turretDir max _relativeDir) - (_turretDir min _relativeDir);
		[["_turret: ",_turret," _turretVector: ",_turretVector," _turretDir: ",_turretDir," _relativeDir: ",_relativeDir," _currentRotTolerance: ",_currentRotTolerance],false] call KISKA_fnc_log;

		// get target alt
		call _fn_updateTargetPos;
		_targetAlt = _targetPos select 2;

		if (call _fn_isNullTarget) exitWith {
			[[_turret," stopped waiting on null target #2"],false] call KISKA_fnc_log;
			true
		};

		if (
			(_currentPitchTolerance <= _pitchTolerance AND
			{_currentRotTolerance <= _rotationTolerance} AND
			{_targetALt >= _engageAboveAltitude})/* OR

			{(_turret distance _target) >= (_searchDistance * 0.75)}*/
		)
		exitWith {
			[[_turret," got an angle on ",_target],false] call KISKA_fnc_log;
			true
		};

		sleep 0.25;
		[[_turret," sleep 0.25"],false] call KISKA_fnc_log;

		false
	};
};

private _fn_whileTargetsIncoming = {
	[[_turret," found targets"],false] call KISKA_fnc_log;

	// while there are still targets in the air; this was orginally a simple for loop, but the alarm sound requires the extra complication of
	/// searching for incoming projectiles constantly after the first is detected
	while {
		[[_turret," sleep 0.5, _fn_whileTargetsIncoming"],false] call KISKA_fnc_log;
		sleep 0.5;
		call _fn_updateIncomingList;
		// if projectiles are still incoming
		if !(_incoming isEqualTo []) then {true} else {false}
	} do {
		// check if sound alarm requested and that the alarm is not already sounding
		if (_soundAlarm AND {!(_turret getVariable ["KISKA_CIWS_alarmSounding",false])}) then {
			// sound alarm
			[_turret] spawn KISKA_fnc_ciwsAlarm;
		};

		[[_turret," searching through targets"],false] call KISKA_fnc_log;
		_targetIndex = _incoming findIf {
			// check if another turret is already engaging the target
			!((_x call BIS_fnc_netId) in KISKA_CIWS_engagedTargetsHash) AND
			{(_x distance _turret) > 25}
		};

		if (_targetIndex != -1) then {
			_target = _incoming select _targetIndex;
			_targetNetId = _target call BIS_fnc_netId;
			_targetDistance = _target distance _turret;

			[[_turret," found target ",_target," at ",_targetDistance,". Its netId is: ",_targetNetId],false] call KISKA_fnc_log;

			call _fn_waitToFireOnTarget

			call _fn_fireAtTarget

		} else {
			[[_turret," target, ",_target," did not meet params"],false] call KISKA_fnc_log;
			//sleep 0.5;
		};
	};

};

private _fn_fireAtTarget = {
	if (!(isNull _target) AND {(_turret distance _target) <= _searchDistance}) then {
		[[_turret," got params met on ",_target],false] call KISKA_fnc_log;

		// track if unit actually got off shots
		_firedShots = false;
		private _numberOfShots = random [50,100,150];
		[["_numberOfShots is:",_numberOfShots]] call KISKA_fnc_log;

		private _shotMin = _numberOfShots / 3;
		[["_shotMin is: ",_shotMin],false] call KISKA_fnc_log;

		private _explodeAtShot = round (random [_shotMin,_shotMin * 2,_numberOfShots]);
		[["_explodeAtShot is: ",_explodeAtShot],false] call KISKA_fnc_log;

		private _didExplode = false;
		private "_engagedBy";

		for "_i" from 1 to _numberOfShots do {

			if (isNull _target) exitWith {
				[[_turret," target became null"],false] call KISKA_fnc_log;
			};

			_engagedBy = KISKA_CIWS_engagedTargetsHash getOrDefault [_targetNetId, objNull];
			[[_target," is currently engaged by ",_engagedBy,". NetId is: ",_targetNetId],false] call KISKA_fnc_log;

			// check if target was engaged by another turret
			if (!(isNull _engagedBy) AND {_engagedBy isNotEqualTo _turret}) exitWith {
				[[_turret," will not engage ",_target,"; It's already being engaged by ",_engagedBy],false] call KISKA_fnc_log;
			};

			// keep watching target
			_turret lookAt _target;
			_turretPitchAngle = (deg (_turret animationSourcePhase "maingun")) + 0.6;

			// only fire above specified angle
			if (_turretPitchAngle >= _doNotFireBelowAngle) then {
				// ensure target is not engaged by other turrets
				if (isNull _engagedBy) then {
					[[_turret," is set to engage ",_target,". NetId is: ",_targetNetId],false] call KISKA_fnc_log;
					KISKA_CIWS_engagedTargetsHash set [_targetNetId,_turret];
				};

				// turret shoots 1 round
				_turret fireAtTarget [_target,currentWeapon _turret];

				// create explosion
				if (!_didExplode AND {_i >= _explodeAtShot}) then {
					["Reached explosion, updating target pos",false] call KISKA_fnc_log;
					call _fn_updateTargetPos;

					// delay explosion because bullets take time to reach their target
					if (!isNull _target) then {
						[["Creating an explosion for target ",_target," for turret ",_turret]] call KISKA_fnc_log;

						[_turret,_targetPos] spawn {
							params ["_turret","_targetPos"];

							// bullet travels about 1m every 0.0005s
							private _sleep = (EXPLOSION_DELAY_CONST * (_turret distance _targetPos));
							sleep _sleep;
							createVehicle ["HelicopterExploBig",_targetPos,[],0,"FLY"];
						};

						// stop target so it doesn't hit something
						_target setVelocity [0,0,0];
					};

					_didExplode = true;
				};

				// update if unit fired
				if (!_firedShots) then {
					_firedShots = true;
				};

				[[_turret," fired at ",_target," shot number ",_i],false] call KISKA_fnc_log;
			};

			sleep 0.01;
		};

		// reset lookAt
		_turret lookAt objNull;
		// sometimes the turret locks up in its aiming animations (becomes slow to aim)
		// this is used as a sort of reset
		_turret disableAI "WEAPONAIM";

		if (
			!(isNull _target) AND
			{_firedShots} AND
			{KISKA_CIWS_engagedTargetsHash getOrDefault [_targetNetId, objNull] isEqualTo _turret}
		) then {
			triggerAmmo _target;

			// remove from target hash
			[["Removed turret ",_turret," from target hash for target ",_target," with a netId of: ",_targetNetId],false] call KISKA_fnc_log;
			KISKA_CIWS_engagedTargetsHash deleteAt _targetNetId;

			if (alive _target) then {
				deleteVehicle _target;
			};

			[[_turret," destroyed target ",_target],false] call KISKA_fnc_log;
		};

	} else {
		// reset lookAt
		_turret lookAt objNull;
		_turret disableAI "WEAPONAIM";

		[[_turret," target ",_target," did not meet params"],false] call KISKA_fnc_log;
	};
};


_turret disableAI "AutoTarget";
_turret disableAI "Target";

while {alive _turret AND {_turret getVariable ["KISKA_runCIWS",true]}} do {
	// get incoming projectiles
	call _fn_updateIncomingList;

	// if projectiles are present then proceed, else sleep
	if !(_incoming isEqualTo []) then {
		call _fn_whileTargetsIncoming;

		// turn off alarm if used
		if (_soundAlarm) then {
			call _fn_checkIfStopAlarm
		};

	} else {
		[[_turret," sleep 0.5, the target did not meet params"],false] call KISKA_fnc_log;
		sleep _searchInterval;
	};
};

if (alive _turret) then {
	_turret enableAI "AutoTarget";
	_turret enableAI "Target";
	// enable HC transfer
	[group _turret,false] call KISKA_fnc_ACEX_setHCTransfer;
};


RETURN_NIL
