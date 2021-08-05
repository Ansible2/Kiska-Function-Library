/* ----------------------------------------------------------------------------
Function: KISKA_fnc_helicopterGunner

Description:
	Spawns a helicopter that will partol a given area for a period of time and
	 engage enemy targets in a given area.

Parameters:
	0: _centerPosition : <ARRAY(AGL), OBJECT> - The position around which the helicopter will patrol
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
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_helicopterGunner";

#define SPAWN_DISTANCE 2000
#define DETECT_ENEMY_RADIUS 700
#define MIN_RADIUS 200
#define STAR_BEARINGS [0,144,288,72,216]

params [
	"_centerPosition",
	["_radius",200,[123]],
	["_aircraftType","",[""]],
	["_timeOnStation",180,[123]],
	["_supportSpeedLimit",10,[123]],
	["_flyInHeight",30,[123]],
	["_approachBearing",-1,[123]],
	["_side",BLUFOR,[sideUnknown]]
];


/* ----------------------------------------------------------------------------
	verify vehicle has turrets that are not fire from vehicle and not copilot positions
---------------------------------------------------------------------------- */
private _turretsWithWeapons = [_aircraftType] call KISKA_fnc_classTurretsWithGuns;

// go to default aircraft type if no suitable turrets are found
if (_turretsWithWeapons isEqualTo []) exitWith {
	[[_aircraftType," does not meet standards for function!"],true] call KISKA_fnc_log;
	[]
};


/* ----------------------------------------------------------------------------
	Create vehicle
---------------------------------------------------------------------------- */
if (_approachBearing < 0) then {
	_approachBearing = round (random 360);
};
private _spawnPosition = _centerPosition getPos [SPAWN_DISTANCE,_approachBearing + 180];
_spawnPosition set [2,_flyInHeight];

private _vehicleArray = [_spawnPosition,0,_aircraftType,_side] call KISKA_fnc_spawnVehicle;
// disable HC transfer
private _pilotsGroup = _vehicleArray select 2;
[_pilotsGroup,false] call KISKA_fnc_ACEX_setHCTransfer;

private _vehicle = _vehicleArray select 0;
_vehicle flyInHeight _flyInHeight;
// notify side if destroyed
_vehicle addEventHandler ["KILLED",{
	params ["_vehicle"];
	//[TYPE_HELO_DOWN,_vehicleCrew select 0,_side] call KISKA_fnc_supportRadio;

	(crew _vehicle) apply {
		if (alive _x) then {
			deleteVehicle _x
		};
	};
}];



private _vehicleCrew = _vehicleArray select 1;


/* ----------------------------------------------------------------------------
	Move to support zone
---------------------------------------------------------------------------- */
// move command only supports position arrays
if (_centerPosition isEqualType objNull) then {
	_centerPosition = getPosATL _centerPosition;
};

private _params = [
	_centerPosition,
	_radius,
	_timeOnStation,
	_supportSpeedLimit,
	_approachBearing,
	_side,
	_vehicle,
	_pilotsGroup,
	_vehicleCrew
];

_params spawn {
	params [
		"_centerPosition",
		"_radius",
		"_timeOnStation",
		"_supportSpeedLimit",
		"_approachBearing",
		"_side",
		"_vehicle",
		"_pilotsGroup",
		"_vehicleCrew"
	];

	// once you go below a certain radius, it becomes rather unnecessary
	if (_radius < MIN_RADIUS) then {
		_radius = MIN_RADIUS;
	};

	// move to support zone
	waitUntil {
		if ((!alive _vehicle) OR {(_vehicle distance2D _centerPosition) <= _radius}) exitWith {
			true
		};
		_pilotsGroup move _centerPosition;
		sleep 2;
		false
	};


	/* ----------------------------------------------------------------------------
		Do support
	---------------------------------------------------------------------------- */

	[
		_vehicle,
		5,
		4,
		_radius * 2,
		1,
		true
	] spawn KISKA_fnc_engageHeliTurretsLoop;

	// to keep helicopters from just wildly flying around
	_vehicle limitSpeed _supportSpeedLimit;

	private _sleepTime = _timeOnStation / 5;
	for "_i" from 0 to 4 do {

		if (!alive _vehicle) then {
			break;
		};
		_vehicle doMove (_centerPosition getPos [_radius,STAR_BEARINGS select _i]);
		sleep _sleepTime;

	};

	_vehicle setVariable ["KISKA_heliTurrets_endLoop",true];

	/* ----------------------------------------------------------------------------
		After support is done
	---------------------------------------------------------------------------- */
	//[TYPE_CAS_ABORT,_vehicleCrew select 0,_side] call KISKA_fnc_supportRadio;

	// remove speed limit
	_vehicle limitSpeed 99999;

	// get helicopter to disengage and rtb
	(currentPilot _vehicle) disableAI "AUTOTARGET";
	_pilotsGroup setCombatMode "BLUE";

	// not using waypoints here because they are auto-deleted for an unkown reason a few seconds after being created for the unit

	// return to spawn position area
	private _deletePosition = _centerPosition getPos [SPAWN_DISTANCE,_approachBearing + 180];
	_vehicle doMove _deletePosition;

	waitUntil {
		if (!alive _vehicle OR {(_vehicle distance2D _deletePosition) <= 200}) exitWith {true};

		// if vehicle is disabled and makes a landing, just blow it up
		if ((getPosATL _vehicle select 2) < 2) exitWith {
			_vehicle setDamage 1;
			true
		};

		sleep 2;
		false
	};


	_vehicleCrew apply {
		if (alive _x) then {
			_vehicle deleteVehicleCrew _x;
		};
	};
	if (alive _vehicle) then {
		deleteVehicle _vehicle;
	};
};


_vehicleArray
