/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciws

Description:
	Fires a number of rounds from artillery piece at target with random disperstion values

Parameters:
	0: _turret : <OBJECT> - The CIWS turret
	1: _alertDistance : <NUMBER> - How far out will the CIWS be notified of a target
	2: _rounds : <NUMBER> - Number of rounds to fire


Returns:
	Nothing

Examples:
    (begin example)

		null = [] spawn KISKA_fnc_ciws;

    (end)

Author:
	DayZMedic,
	modified/optimized by Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ciws";

if (!canSuspend) exitWith {
	"Must be run in scheduled envrionment" call BIS_fnc_error
};

params [
	["_turret",objNull,[objNull]],
	["_alertDistance",3000,[123]]
];

if (isNull _turret) exitWith {
	"_turret isNull" call BIS_fnc_error
};
if !(_turret isKindOf "AAA_System_01_base_F") exitWith {
	"Improper turret type used" call BIS_fnc_error
};


while {alive _turret} do {
	// nearestObjects and nearEntities do not work here
	// get incoming projectiles
	private _incoming = _turret nearObjects ["RocketBase",_alertDistance];
	_incoming = _incoming + (_turret nearObjects ["MissileBase",_alertDistance]);
	_incoming = _incoming + (_turret nearObjects ["ShellBase",_alertDistance]);
	
	// if projectiles are present then proceed, else sleep
	if !(_incoming isEqualTo []) then {
		
		for "_i" from 0 to ((count _incoming) -1) do {
			_turret setCombatMode "RED";
			private _target = _incoming select _i;
			private _targetDistance = _target distance _turret;
			
			if (_targetDistance > 100) then {
				
	
				waitUntil {
					_turret doWatch _target;

					private _turretVector = _turret weaponDirection (currentWeapon tests);
					private _turretDir = (_turretVector select 0) atan2 (_turretVector select 1);
					private _relativeDir = _turret getRelDir _target;
					
					// get the degree between where the target is at relative to the turret position
					private _tolerance = (selectMax [_turretDir,_relativeDir]) - (selectMin [_turretDir,_relativeDir]);
					hint str [_turretDir,_relativeDir,_tolerance];

					// 2 degree tolerance range before we start shooting
					if (_tolerance <= 10 OR {(_turret distance _target) >= (_alertDistance / 2)}) exitWith {_turret setCombatMode "RED"; hint "exit"; true};
					
					systemChat "aligning";

					sleep 0.25; 
					
					false
				};

				if ((_turret distance _target) <= (_alertDistance / 2)) then {
					hint "aligned";

					for "_y" from 0 to (random [50,100,150]) do {
						_turret fireAtTarget [_target,currentWeapon _turret];
						sleep 0.01;
					};

					sleep ((_target distance _turret)/1000) + 1;

					private _targetPos = getPosATL _target;
					private _targetBoom = getText (configFile >> "CfgAmmo" >> (typeOf _target) >> "explosionEffects");
					createVehicle [_targetBoom,_targetPos,[],0,"CAN_COLLIDE"];
					createVehicle ["HelicopterExploBig",_targetPos,[],0,"CAN_COLLIDE"];
					
					deleteVehicle _target;
				};
			};

			_turret setCombatMode "GREEN";
		};

	} else {
		sleep 1;
	};
};