#include "..\..\Headers\Support Framework\CAS Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CAS

Description:
    Completes either a gun run, bomb run, rockets, or rocket and gun strike.

Parameters:
    0: _attackPosition : <OBJECT or PositionASL[]> - ASL position or object to attack
    1: _attackTypeID : <NUMBER or ARRAY> - See CAS Type IDs.hpp .
        If an array, format needs to be [attackTypeId,pylonMagazineClass].
        Custom mag classes, when used for napalm or UGB ids, will drop the ENTIRE payload
         of that mag. e.g. mag class "vn_bomb_f4_out_500_blu1b_fb_mag_x1" is 1 bomb dropped,
         "vn_bomb_f4_out_500_blu1b_fb_mag_x4" will be 4 dropped
    2: _attackDirection : <NUMBER> - The direction the aircraft should approach from relative to North
    3: _planeClass : <STRING> - The className of the aircraft
    4: _side : <SIDE> - The side of the plane
    5: _spawnHeight : <NUMBER> - At what height should the aircraft start firing
    6: _spawnDistance : <NUMBER> - How far away to spawn the aircraft
    7: _breakOffDistance : <NUMBER> - The distance to target at which the aircraft should definately disengage and fly away (to not crash)
    8: _attackPositionOffset : <NUMBER> - This will offset the _attackPosition in meters and in the direction of the attack.
        So for instance, if I wanted a gun run to be aimed 20m further in the _attackDirection from the _attackPosition, I'd
         set this to 20
    9: _attackDistance : <NUMBER> - The distance to target at which the aircraft can start completeing its attack
    10: _allowDamage : <BOOL> - Allow damage of both the crew and aircraft

Returns:
    NOTHING

Examples:
    (begin example)
        [myTarget] call KISKA_fnc_CAS;
    (end)

Author(s):
    Bohemia Interactive,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CAS";

#define DEFAULT_CANNON_CLASS "Twin_Cannon_20mm"
#define DEFAULT_CANNON_MAG_CLASS "PylonWeapon_300Rnd_20mm_shells"

#define DEFAULT_AIRCRAFT "B_Plane_CAS_01_dynamicLoadout_F"

#define PLANE_SPEED 75// m/s
#define PLANE_VELOCITY(THE_SPEED) [0,THE_SPEED,0]

#define CUSTOM_OR_DEFAULT_MAG(defaultClass) [_customMagClass,defaultClass] select (_customMagClass isEqualTo "")

#define STRAFE_INCREMENT 0.1
#define FLARE_COUNT 4
#define TIME_TILL_DELETE 64

params [
    ["_attackPosition",objNull,[[],objNull]],
    ["_attackTypeID",0,[123,[]]],
    ["_attackDirection",0,[123]],
    ["_planeClass",DEFAULT_AIRCRAFT,[""]],
    ["_side",BLUFOR,[sideUnknown]],
    ["_spawnHeight",1300,[123]],
    ["_spawnDistance",2000,[123]],
    ["_breakOffDistance",500,[123]],
    ["_attackPositionOffset",0,[123]],
    ["_attackDistance",1200,[123]],
    ["_allowDamage",false,[true]]
];


if (
	(_attackPosition isEqualType objNull) AND 
	{isNull _attackPosition} OR 
	{_attackPosition isEqualTo []}
) exitWith {
    [[_attackPosition," is an invalid target"],true] call KISKA_fnc_log;
    nil
};

private _planeCfg = configfile >> "cfgvehicles" >> _planeClass;
if !(isclass _planeCfg) exitwith {
    [[_planeClass," Vehicle class not found, moving to default aircraft..."],true] call KISKA_fnc_log;
    _this set [3,DEFAULT_AIRCRAFT];
    _this call KISKA_fnc_CAS;
};


/* ----------------------------------------------------------------------------
    select weapons to use
---------------------------------------------------------------------------- */
private _attackMagazines = [];
private _customMagClass = "";

if (_attackTypeID isEqualType []) then {
    _customMagClass = _attackTypeID select 1;
    _attackTypeID = _attackTypeID select 0;
};

_attackMagazines = switch _attackTypeID do {
    case GUN_RUN_ID: {
        [CANNON_TYPE]
    };
    case GUNS_AND_ROCKETS_ARMOR_PIERCING_ID: {
        [
			CANNON_TYPE,
			[ROCKETS_AP_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonRack_7Rnd_Rocket_04_AP_F")]
		]
    };
    case GUNS_AND_ROCKETS_HE_ID: {
        [
			CANNON_TYPE,
			[ROCKETS_HE_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonRack_7Rnd_Rocket_04_HE_F")]
		]
    };
    case ROCKETS_ARMOR_PIERCING_ID: {
        [[ROCKETS_AP_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonRack_7Rnd_Rocket_04_AP_F")]]
    };
    case ROCKETS_HE_ID: {
        [[ROCKETS_HE_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonRack_7Rnd_Rocket_04_HE_F")]]
    };
    case AGM_ID: {
        [[AGM_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonRack_1Rnd_Missile_AGM_02_F")]]
    };
    case BOMB_LGB_ID: {
        [[BOMB_LGB_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonMissile_1Rnd_Bomb_04_F")]]
    };
    case BOMB_CLUSTER_ID: {
        [[BOMB_UGB_TYPE, CUSTOM_OR_DEFAULT_MAG("PylonMissile_1Rnd_BombCluster_01_F")]]
    };
    case BOMB_NAPALM_ID: {
        [[BOMB_UGB_TYPE, CUSTOM_OR_DEFAULT_MAG("vn_bomb_f4_out_500_blu1b_fb_mag_x1")]]
    };
};


private _exitToDefault = false;


////// Verify the plane has the right weapons for what is asked of it and adjust if it doesn't //////
private _weaponsToUse = [];
private _planeClassWeapons = _planeClass call BIS_fnc_weaponsEntityType;
private _pylonConfig = _planeCfg >> "Components" >> "TransportPylonsComponent" >> "pylons";

// if the plane has pylons
if (isClass _pylonConfig) then {

    private _allVehiclePylons = ("true" configClasses _pylonConfig) apply {configName _x};

    // some planes (Buzzard) have their cannon as a pylon, don't want to replace it if needed
    if (CANNON_TYPE in _attackMagazines) then {

        // find the cannon weapon in the planes default loadout
        private _cannonIndex = _planeClassWeapons findIf {
            [
                (configFile >> "cfgWeapons" >> _x),
                (configFile >> "cfgWeapons" >> "cannonCore")
            ] call CBA_fnc_inheritsFrom;
        };

        private _cannonClass = "";
        // if a cannon is found, use it, else add one
        private _canonPylonData = [];
        if (_cannonIndex != -1) then {
            _cannonClass = _planeClassWeapons select _cannonIndex;

            // if the cannon is on a pylon delete the pylon from the list so it's not changed
            private _cannonPylonIndex = _allVehiclePylons findIf {
                getText(_pylonConfig >> _x >> "attachment") == _cannonClass;
            };
            if (_cannonPylonIndex isNotEqualTo -1) then {
                _allVehiclePylons deleteAt _cannonPylonIndex;
            };

        } else {
            _cannonClass = DEFAULT_CANNON_CLASS;
            _canonPylonData pushBack DEFAULT_CANNON_MAG_CLASS;
            private _pylonToUse = _allVehiclePylons deleteAt 0; // set the first pylon as the cannon
            _canonPylonData pushBack _pylonToUse;

        };

        _weaponsToUse pushBack [CANNON_TYPE,_cannonClass,_canonPylonData];
        // remove cannon so we don't need to check it later
        _attackMagazines deleteAt (_attackMagazines find CANNON_TYPE);

    };

    // if there was more then just the cannon in the _attackMagazines array
    if (_attackMagazines isNotEqualTo []) then {
        {
			_x params ["_attackTypeString","_attackMagazineClass"];
            private _attackWeaponClass = [
				configFile >> "cfgMagazines" >> _attackMagazineClass >> "pylonWeapon"
			] call BIS_fnc_getCfgData;

            // pushBack string for attack type, the weapon used, the mag for adding a pylon, and what pylon to add it to
			private _nextPylon = _allVehiclePylons deleteAt 0;
            _weaponsToUse pushBack [
				_attackTypeString,
				_attackWeaponClass,
				[_attackMagazineClass, _nextPylon]
			];
        } forEach _attackMagazines;
    };

} else {
    _exitToDefault = true;

};


if (_exitToDefault) exitwith {
    [
		[
			"Weapon types of ",
			_attackMagazines,
			" for plane class: ",
			_planeClass,
			" not entirely found, moving to default Aircraft..."
		],
		true
	] call KISKA_fnc_log;

    // exit to default aircraft type
    _this set [3,DEFAULT_AIRCRAFT];
    _this call KISKA_fnc_CAS;
};



/* ----------------------------------------------------------------------------
    Position plane towards target
---------------------------------------------------------------------------- */
// angling the plane towards the target
if (_attackPosition isEqualType objNull) then {
    _attackPosition = getPosASL _attackPosition;
};
private _planeSpawnPosition = [
    _attackPosition,
    _spawnDistance,
    _attackDirection + 180,
    _spawnHeight
] call KISKA_fnc_getPosRelativeASL;
private _planeArray = [
	_planeSpawnPosition,
	_attackDirection,
	_planeClass,
	_side
] call KISKA_fnc_spawnVehicle;
_planeArray params ["_plane","_crew","_planeGroup"];
[_planeGroup,true] call KISKA_fnc_ACEX_setHCTransfer;

if !(_allowDamage) then {
    _plane allowDamage false;
    _crew apply {
        _x allowDamage false;
    };
};


// update the planes pylons
_weaponsToUse apply {
    private _pylonData = _x select 2;
    // the cannon may not have any pylon data and therefore _pylonData will be []
    if !(_pylonData isEqualTo []) then {
        (_x select 2) params ["_magClass","_pylon"];
        _plane setPylonLoadout [_pylon,_magClass,true];
    };
};



_plane setPosASL _planeSpawnPosition;
_plane setDir _attackDirection;
_plane disableAi "autotarget";
_plane setCombatMode "blue";

if (_attackPositionOffset isNotEqualTo 0) then {
    _attackPosition = AGLToASL(_attackPosition getPos [_attackPositionOffset,_attackDirection]);
};



private _planePositionASL = getPosASLVisual _plane;
private _vectors = [_planePositionASL,_attackPosition] call KISKA_fnc_getVectorToTarget;
_plane setVectorDirAndUp _vectors;
_vectors params ["_planeVectorDirTo","_planeVectorUp"];

/* ----------------------------------------------------------------------------
    Fix planes velocity towards the target
---------------------------------------------------------------------------- */
// get flight characteristics to steer the plane onto target
private _vectorDistanceToTarget = _attackPosition vectorDistance _planePositionASL;
private _flightTime = (_vectorDistanceToTarget - _breakOffDistance) / PLANE_SPEED;
private _startTime = time;
private _timeAfterFlight = time + _flightTime;

[
	{
		params ["_args","_id"];
		_args params [
			"_plane",
			"_originalAttackPosition",
			"_attackDirection",
			"_breakOffDistance",
			"_planeSpawnPosition",
			"_startTime",
			"_timeAfterFlight",
			"_planeSpawnPosition",
			"_planeArray",
			"_weaponsToUse",
			"_attackTypeID",
			"_planeVectorDirTo",
			"_planeVectorUp",
			"_side",
			"_attackDistance",
			"_spawnHeight"
		];

		private _attackPosition = _plane getVariable ["KISKA_CAS_attackPosition",_originalAttackPosition];
		private _planePositionASL = getPosASLVisual _plane;
		private _vectorDistanceToTarget = _attackPosition vectorDistance _planePositionASL;

		if (
			isNull _plane OR
			{_plane getVariable ["KISKA_CAS_completedFiring",false]} OR
			{_vectorDistanceToTarget <= _breakOffDistance}
		)
		exitWith {
			/* ----------------------------------------------------------------------------
				Handle After CAS complete
			---------------------------------------------------------------------------- */
			// telling the plane to ultimately fly past the target after we're done controlling it
			_plane move (_attackPosition getPos [5000,_attackDirection]);

			// after fire is complete
			_plane flyInHeight (_spawnHeight * 2);

			// pop flares
			private _pilot = currentPilot _plane;
			for "_i" from 1 to FLARE_COUNT do {
				[
					{
						params ["_pilot"];
						_pilot forceweaponfire ["CMFlareLauncher","Burst"];
					},
					[_pilot],
					_i
				] call CBA_fnc_waitAndExecute;
			};

			// give the plane some time to get out of audible distance before deletion
			[
				{
					params ["_plane","_crew","_group"];

					_crew apply {
						if (!isNull _x) then {
							_plane deleteVehicleCrew _x;
						};
					};

					if (alive _plane) then {
						deleteVehicle _plane;
					};

					if (!isNull _group) then {
						deleteGroup _group;
					};
				},
				_planeArray,
				TIME_TILL_DELETE
			] call CBA_fnc_waitAndExecute;

			[_id] call CBA_fnc_removePerFrameHandler;
		};

		//--- Set the plane approach vector
		private _interval = linearConversion [_startTime,_timeAfterFlight,time,0,1];
		private _velocity = (vectorNormalized (_attackPosition vectorDiff _planePositionASL)) vectorMultiply PLANE_SPEED;
		_plane setVelocityTransformation [
			_planeSpawnPosition, _attackPosition,
			_velocity, _velocity,
			_planeVectorDirTo, _planeVectorDirTo,
			_planeVectorUp, _planeVectorUp,
			_interval
		];

		// start firing
		// check if plane is from target and hasn't already started shooting
		if (_vectorDistanceToTarget > _attackDistance) exitWith {};

		if !(_plane getVariable ["KISKA_CAS_startedFiring",false]) then {
			_plane setVariable ["KISKA_CAS_startedFiring",true];
			// create a target to shoot at
			private _dummyTargetClass = ["LaserTargetE","LaserTargetW"] select ((_side getfriend west) > 0.6);
			private _dummyTarget = createvehicle [_dummyTargetClass,[0,0,0],[],0,"NONE"];
			_plane setVariable ["KISKA_CAS_dummyTarget",_dummyTarget];
			_dummyTarget setPosASL _attackPosition;
			private _laserTarget = laserTarget _dummyTarget;
			_plane reveal _laserTarget;
			_plane dowatch _laserTarget;
			_plane dotarget _laserTarget;

			[
				_plane,
				_dummyTarget,
				_weaponsToUse,
				_attackTypeID,
				_attackPosition,
				_breakOffDistance
			] spawn KISKA_fnc_CASAttack;

		} else {
			// ensures strafing effect with the above setVelocityTransformation
			private _dummyTarget = _plane getVariable "KISKA_CAS_dummyTarget";
			private _nextAttackPostition = _dummyTarget getPos [STRAFE_INCREMENT,(getDirVisual _plane)];
			// did this here for readability
			_nextAttackPostition = AGLToASL _nextAttackPostition;
			
			_plane setVariable ["KISKA_CAS_attackPosition",_nextAttackPostition];
			_dummyTarget setPosASL _nextAttackPostition;
		};

	},
	0.01,
	[
		_plane,
		_attackPosition,
		_attackDirection,
		_breakOffDistance,
		_planeSpawnPosition,
		_startTime,
		_timeAfterFlight,
		_planeSpawnPosition,
		_planeArray,
		_weaponsToUse,
		_attackTypeID,
		_planeVectorDirTo,
		_planeVectorUp,
		_side,
		_attackDistance,
		_spawnHeight
	]
] call CBA_fnc_addPerframeHandler;


nil
