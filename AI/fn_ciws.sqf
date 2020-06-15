/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciws

Description:
	Fires a number of rounds from artillery piece at target with random disperstion values

Parameters:
	0: _turret : <OBJECT> - The CIWS turret
	1: _searchDistance : <NUMBER> - How far out will the CIWS be notified of a target
	2: _engageAltitude : <NUMBER> - What altittiude (AGL) does the target need to be above to be engaged
	3: _searchInterval : <NUMBER> - Time between checks for targets in area
	4: _doNotFireBelowAngle : <NUMBER> - Below what angle should the turret NOT fire (keep it from firing at ground accidently)
	5: _pitchTolerance : <NUMBER> - How accurate does the turrets pitch need to be to engage the target
	6: _rotationTolerance : <NUMBER> - How accurate does the turrets rotation need to be to engage the target



Returns:
	Nothing

Examples:
    (begin example)

		null = [turret,3000,100] spawn KISKA_fnc_ciws;

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
	["_searchDistance",3000,[123]],
	["_engageAltitude",100,[123]],
	["_searchInterval",2,[123]],
	["_doNotFireBelowAngle",5,[123]],
	["_pitchTolerance",3,[123]],
	["_rotationTolerance",10,[123]]
];

if (isNull _turret) exitWith {
	"_turret isNull" call BIS_fnc_error
};
if !(_turret isKindOf "AAA_System_01_base_F") exitWith {
	"Improper turret type used" call BIS_fnc_error
};

_turret setVariable ["KISKA_runCIWS",true];

while {alive _turret AND {_turret getVariable ["KISKA_runCIWS",true]}} do {
	// nearestObjects and nearEntities do not work here
	// get incoming projectiles
	private _incoming = _turret nearObjects ["RocketBase",_searchDistance];
	_incoming = _incoming + (_turret nearObjects ["MissileBase",_searchDistance]);
	_incoming = _incoming + (_turret nearObjects ["ShellBase",_searchDistance]);
	
	// if projectiles are present then proceed, else sleep
	if !(_incoming isEqualTo []) then {
		
		for "_i" from 0 to ((count _incoming) - 1) do {
			_turret setCombatMode "RED";
			private _target = _incoming select _i;
			private _targetDistance = _target distance _turret;

			if (_targetDistance > 25 AND {!(_target getVariable ["KISKA_CIWS_engaged",false])}) then {
				waitUntil {
					// keep turret rotating to target
					_turret doWatch _target;

					//// turrett pitch
					
					// get turrets pitch angle (0.6 offset is baked into source anim)
					private _turretPitchAngle = (deg (_turret animationSourcePhase "maingun")) + 0.6;
					// get the angle needed to target
					private _angleToTarget = acos ((_turret distance2D _target) / (_turret distance _target));
					// get the difference between turrets current pitch and the targets actual angle
					private _currentPitchTolerance = (selectMax [_turretPitchAngle,_angleToTarget]) - (selectMin [_turretPitchAngle,_angleToTarget]);
					

					//// turret rotation
					
					// get turrets rotational angle
					private _turretVector = _turret weaponDirection (currentWeapon _turret);
					private _turretDir = (_turretVector select 0) atan2 (_turretVector select 1);
					_turretDir = [_turretDir] call CBA_fnc_simplifyAngle;
					// get relative rotational angle to the target
					private _relativeDir = _turret getDir _target;				
					// get the degree between where the target is at relative to the turret position and its actual gun
					private _currentRotTolerance = (selectMax [_turretDir,_relativeDir]) - (selectMin [_turretDir,_relativeDir]);

					
					// get target alt
					private _targetAlt = (getPosWorldVisual _target) select 2;
					
					systemChat str [_currentRotTolerance,_rotationTolerance,_currentPitchTolerance,_pitchTolerance,_targetAlt];
					
					if ((_currentPitchTolerance <= _pitchTolerance AND {_currentRotTolerance <= _rotationTolerance} AND {_targetALt >= _engageAltitude}) OR {(_turret distance _target) >= (_searchDistance * 0.75)} OR {!alive _target}) exitWith {hint "exit"; true};

					sleep 0.25; 
					
					false
				};

				if ((_turret distance _target) <= _searchDistance AND {alive _target}) then {
					//sleep 0.5;

					hint "aligned";

					// track if unit actually got off shots
					private _firedShots = false;

					for "_y" from 0 to (random [50,100,150]) do {
						// keep watching target
						_turret doWatch _target;
						private _turretPitchAngle = (deg (_turret animationSourcePhase "maingun")) + 0.6;
						
						// only fire above specified angle
						if (_turretPitchAngle >= _doNotFireBelowAngle) then {
							// ensure target is not reEngaged
							if !(_target getVariable ["KISKA_CIWS_engaged",false]) then {
								_target setVariable ["KISKA_CIWS_engaged",true];
							};
							hint "buuuuurrrrrt";
							// update if unit fired
							if (!_firedShots) then {
								_firedShots = true;
							};
							// turret shoots
							_turret fireAtTarget [_target,currentWeapon _turret];
						};

						sleep 0.01;
					};

					sleep 0.5;

					// only delete if shots were fired
					if (_firedShots) then {
						private _targetPos = getPosWorldVisual _target;
						private _targetBoom = getText (configFile >> "CfgAmmo" >> (typeOf _target) >> "explosionEffects");
						createVehicle [_targetBoom,_targetPos,[],0,"CAN_COLLIDE"];
						createVehicle ["HelicopterExploBig",_targetPos,[],0,"CAN_COLLIDE"];
						
						deleteVehicle _target;
					};
				} else {
					sleep 0.5;
				};
				sleep 0.5;
			};
		};

	} else {
		sleep _searchInterval;
	};
};