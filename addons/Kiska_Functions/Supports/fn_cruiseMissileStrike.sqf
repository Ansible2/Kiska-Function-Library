/* ----------------------------------------------------------------------------
Function: KISKA_fnc_cruiseMissileStrike

Description:
	Spawns a cruise missile at designated "launcher" and then guides it to a target.

	If you need a missile that terrain follows, see KISKA_fnc_vlsFireAt.

Parameters:
	0: _target <OBJECT or ARRAY> - Target to hit missile with, can also be a position (ASL)
	1: _side <SIDE> - The side that is launching the missile
	2: _launchPos <OBJECT or ARRAY> - An object or position ASL to spawn the missile at.
		If empty array array (default), a random position is chosen 2000m away.

Returns:
	NOTHING

Examples:
    (begin example)
		[target_1] call KISKA_fnc_cruiseMissileStrike;
    (end)

Authors:
	Arma 3 Discord,
	Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_cruiseMissileStrike";

#define VLS_CLASS "B_Ship_MRLS_01_F"
#define MISSILE_CLASS "ammo_Missile_Cruise_01"
#define LASER_TARGET_CLASS "LaserTargetC"
#define LAUNCHER_RAND_SPAWN_DISTANCE 2000
#define LAUNCHER_RAND_SPAWN_ALT 1000

params [
	["_target",objNull,[objNull,[]]],
	["_side",BLUFOR,[sideUnknown]],
	["_launchPos",[],[[],objNull]]
];

private _targetIsObject = _target isEqualType objNull;
if (_targetIsObject AND {isNUll _target}) exitWith {
	["Null _target provided!",true] call KISKA_fnc_log;
	nil
};

private _launchPosIsObject =_launchPos isEqualType objNull;
if (_launchPosIsObject AND {isNUll _launchPos}) exitWith {
	["Null _launchPos provided!",true] call KISKA_fnc_log;
	nil
};

if (_launchPos isEqualTo []) then {
	// get firing position and give it some alititude
	_launchPos = [_target,LAUNCHER_RAND_SPAWN_DISTANCE] call CBA_fnc_randPos;
	_launchPos = _launchPos vectorAdd [0,0,LAUNCHER_RAND_SPAWN_ALT];
};
if (_launchPosIsObject) then {
	_launchPos = getPosASL _launchPos;
};


// spawn the launcher a little lower so missile does not collide
private _launcherGroup = createGroup _side;
// can't use createUnit, causes missile not to track
private _launcher = VLS_CLASS createVehicle [0,0,0];
_launcher allowDamage false;
[_launcherGroup,true] call KISKA_fnc_ACEX_setHCTransfer;
_launcher setPosASL (_launchPos vectorDiff [0,0,7]);
private _tempGroup = createVehicleCrew _launcher;
(units _tempGroup) joinSilent _launcherGroup;

// doesn't need to be simmed to act as shot parent
_launcher enableSimulationGlobal false;


//create Missile
private _missile = MISSILE_CLASS createVehicle [0,0,0];
_missile setPosASL _launchPos;
_missile setVectorDirAndUp [[0, 0, 1], [1, 0, 0]];

if (_targetIsObject) then {
	_target = getPosASL _target;
};
// any (implemented) lasertarget will do, and since independent does not have one, just use civilian
private _laserTarget = createVehicle [LASER_TARGET_CLASS,_target,[],0,"CAN_COLLIDE"];
_laserTarget setPosASL _target;
_side reportRemoteTarget [_laserTarget, 3600];

// Do not remotexec setShotParents on server, causes undefined behaviour
_missile setShotParents [_launcher,gunner _launcher];
_missile setMissileTarget _laserTarget;


[
	[[_missile],{
		_thisArgs params ["_missile"];

		!alive _missile
	}],
	[[_launcher,_laserTarget],{
		_thisArgs params ["_launcher","_laserTarget"];

		deleteVehicle _laserTarget;
		deleteVehicleCrew _launcher;
		deleteVehicle _launcher;
	}],
	5
] call KISKA_fnc_waitUntil;


nil
