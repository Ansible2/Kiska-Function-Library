/* ----------------------------------------------------------------------------
Function: KISKA_fnc_cruiseMissile

Description:
	Spawns a cruise missile at designated launcher and then guides it to a target 

Parameters:
	0: _launcher <OBJECT> - The VLS launcher to have the missile originate from
	1: _target <OBJECT> - Target to hit missile with 
	2: _hangTime <NUMBER> - (OPTIONAL) How long should the missile climb before diverting to target. Default 6 seconds

Returns:
	Nothing

Examples:
    (begin example)

		[VLS_1,target_1,6] spawn KISKA_fnc_initializeRespawnSystem;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!canSuspend) exitWith {};

params [
	["_launcher",objNull,[objNull]],
	["_target",objNull,[objNull]],
	["_hangTime",6,[123]]
];

if (isNull _launcher) exitWith {
	"_launcher must not be null object" call BIS_fnc_error;
};

if !(typeOf _launcher == "B_Ship_MRLS_01_F (VLS1)") exitWith {
	"_launcher must be type B_Ship_MRLS_01_F (VLS1)" call BIS_fnc_error;
}; 

if (_hangTime <= 0) exitWith {
	"_hangTime cannot be zero or negative" call BIS_fnc_error;
};

private _launcherPosition = position _launcher;  
private _missile = "ammo_Missile_Cruise_01" createVehicle [_launcherPosition select 0, _launcherPosition select 1, (_launcherPosition select 2) + 20];  
  
_missile setVectorDirAndUp [[0, 0, 1], [1, 0, 0]];

private _laserTarget = "LaserTargetW" createVehicle (position _target);    
blufor reportRemoteTarget [_laserTarget, 3600];  
  
_missile setShotParents [_launcher,gunner _launcher];  

sleep _hangTime;
  
_missile setMissileTarget _laserTarget; 