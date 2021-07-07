/* ----------------------------------------------------------------------------
Function: KISKA_fnc_cruiseMissile

Description:
	Spawns a cruise missile at designated "launcher" and then guides it to a target 

Parameters:
	0: _launcher <OBJECT> - The VLS launcher to have the missile originate from (or position)
	1: _target <OBJECT or ARRAY> - Target to hit missile with, can also be a position (AGL)
	2: _hangTime <NUMBER> - (OPTIONAL) How long should the missile climb before diverting to target. Default 6 seconds

Returns:
	NOTHING

Examples:
    (begin example)
		[VLS_1,target_1,6] spawn KISKA_fnc_cruiseMissile;
    (end)

Authors:
	Arma 3 Discord,
	modified by - Ansible2
---------------------------------------------------------------------------- */
if (!canSuspend) exitWith {
	["Must be run in scheduled envrionment, exiting to scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_cruiseMissile
};

params [
	["_launcher",objNull,[objNull]],
	["_target",objNull,[objNull,[]]],
	["_hangTime",6,[123]]
];

if (isNull _launcher) exitWith {
	["_launcher is a null object",true] call KISKA_fnc_log;
	nil
};

if (_hangTime <= 0) exitWith {
	["_hangTime cannot be zero or negative",true] call KISKA_fnc_log;
	nil
};

private _launcherPosition = getPosWorld _launcher;
private _missile = "ammo_Missile_Cruise_01" createVehicle [_launcherPosition select 0, _launcherPosition select 1, (_launcherPosition select 2) + 20];  

// create launch effect
private _boosterSmoke = "#particlesource" createVehicle [0,0,0]; 
_boosterSmoke setParticleClass "MLRSFired1";
_boosterSmoke attachto [_missile,[0,0,0],"missileEnd"];

_missile setVectorDirAndUp [[0, 0, 1], [1, 0, 0]];

// get target position
private "_targetPosition";
if (_target isEqualType objNull) then {
	_targetPosition = getPosWorld _target;
} else {
	_targetPosition = _target;
};

private _laserTarget =  createVehicle ["LaserTargetW",_targetPosition,[],0,"CAN_COLLIDE"];    
BLUFOR reportRemoteTarget [_laserTarget, 3600];  
  
_missile setShotParents [_launcher,gunner _launcher];  

sleep _hangTime;
deleteVehicle _boosterSmoke;
_missile setMissileTarget _laserTarget;

waitUntil {
	if (!alive _missile) exitWith {true};
	sleep 10;
	false
};

deleteVehicle _laserTarget;