/* ----------------------------------------------------------------------------
Function: KISKA_fnc_cargoDrop

Description:
	Ejects a vehicle from a cargo plane. Should ideally be used in conjunction with KISKA_fnc_strapCargo 

Parameters:

	0: _vehicleToDrop <OBJECT> - ...

Returns:
	NOTHING

Examples:
    (begin example)

		[vehicle1] call KISKA_fnc_cargoDrop;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
params [
	["_vehicleToDrop",objNull,[objNull]]
];

if (isNull _vehicleToDrop) exitWith {};

// detach from loaded aircraft
private _aircraftLoadedIn = attachedTo _vehicleToDrop;
_vehicleToDrop disableCollisionWith _aircraftLoadedIn;
detach _vehicleToDrop;


// handle vehicle's simulation
[_vehicleToDrop,false] remoteExecCall ["allowDamage",_vehicleToDrop];
[_vehicleToDrop,true] remoteExecCall ["enableSimulationGlobal",2];
if (dynamicSimulationSystemEnabled AND {dynamicSimulationEnabled _vehicleToDrop}) then {
	[_vehicleToDrop,false] remoteExec ["enableDynamicSimulation",2];
};


// decide how to shoot the vehicle out the back of the aircraft depending on how it is oriented
private _relativeFront = ((0 boundingBox _aircraftLoadedIn) select 1) select 1;
private _frontOfAircraftPosition = _aircraftLoadedIn modelToWorld [0,_relativeFront,0];
private _relativeDirection = _vehicleToDrop getRelDir _frontOfAircraftPosition;
private _isBackedIn = if (_relativeDirection > 10 AND {_relativeDirection < 350}) then {true} else {false};


// shoot aircraft out back
[_vehicleToDrop,[0,[-40,40] select _isBackedIn,2]] remoteExecCall ["setVelocityModelSpace",_vehicleToDrop];
_vehicleToLoad setVariable ["KISKA_CargoStrapped",false,true];
// give the vehicle another boost
// this is so the vehicle appears slightly more leveled (like it's actually floating out the back)
// if you set the velocity to high above, the vehicle will trend upwards and clip through the vehicle
[
	{
		params [
			["_vehicleToDrop",objNull,[objNull]]
		];

		private _vehicleVelocity = (velocityModelSpace _vehicleToDrop) select 1;
		[_vehicleToDrop,[0,_vehicleVelocity*2,2]] remoteExecCall ["setVelocityModelSpace",_vehicleToDrop];
	},
	[_vehicleToDrop],
	0.2
] call CBA_fnc_waitAndExecute;
/* ----------------------------------------------------------------------------


---------------------------------------------------------------------------- */
KISKA_fnc_CD_markDropPosition = {
	params ["_vehicleToDrop"];

	private _position = [_vehicleToDrop,15] call CBA_fnc_randPos;
	private _chemlight = createvehicle ["Chemlight_green_infinite",_position,[],0,"NONE"];
	private _smoke = createvehicle ["G_40mm_SmokeBlue_infinite",_position,[],0,"NONE"];
	private _flare = createvehicle ["F_40mm_Red",_position,[],0,"NONE"];

	[
		2,
		{
			params ["_vehicleToDrop","_chemlight","_smoke"];

			[
				{
					params ["_vehicleToDrop"];
					
					[_vehicleToDrop,true] remoteExec ["allowDamage",_vehicleToDrop];
					[_vehicleToDrop,false] remoteExec ["enableDynamicSimulation",2];
				},
				[_vehicleToDrop],
				20
			] call CBA_fnc_waitAndExecute;


			// delete markers
			[_chemlight,_smoke] apply {
				if (!isNull _x) then {
					deleteVehicle _x;
				};
			};
			
			// compensate for vehicles in the ground
			private _vehiclePosition = getPosATL _vehicleToDrop;
			if ((_vehiclePosition select 2) < 0) then {
				_vehicleToDrop setPosATL [_vehiclePosition select 0,_vehiclePosition select 1,0];
			};
		},
		{	// waitUntil a player is within 10 meters of vehicle (2D)
			!(((call CBA_fnc_players) findIf {(_x distance2D (_this select 0)) < 10}) isEqualTo -1)
		},
		[_vehicleToDrop,_chemlight,_smoke]
	] call KISKA_fnc_waitUntil;

};
/* ----------------------------------------------------------------------------


---------------------------------------------------------------------------- */
KISKA_fnc_CD_deployChutes = {
	params [
		["_vehicleToDrop",objNull,[objNull]],
		["_isBackedIn",false,[true]]
	];
	
	// create actual main chute to float the vehicle down
	private _mainChute = createVehicle ["b_parachute_02_F",[0,0,0]];
	_mainChute setPos (getPos _vehicleToDrop);
	_vehicleToDrop attachTo [_mainChute,[0,2,0]];
	_mainChute hideObjectGlobal true;

	// speed up the drop
	[_mainChute] spawn {
		params ["_mainChute"];

		private "_chuteVelocity";
		private _chuteHeight = (getPosATLVisual _mainChute) select 2;
		while {_chuteHeight > 50} do {
			_chuteVelocity = velocityModelSpace _mainChute;
			if (_chuteHeight > 500) then {
				_mainChute setVelocityModelSpace (_chuteVelocity vectorDiff [0,0,90]);
			} else {
				_mainChute setVelocityModelSpace (_chuteVelocity vectorDiff [0,0,35]);
			};
			_chuteHeight = (getPosATLVisual _mainChute) select 2;
			sleep 0.25;
		};
	};

	private _chutesArray = [];
	_chutesArray pushBack _mainChute;

	// create chutes for purely appearance sake
	private _chutePositionArray = if (getMass _vehicleToDrop > 10000) then {
			[[0.5,0.4,0.6],[-0.5,0.4,0.6],[0.5,-0.4,0.6],[-0.5,-0.4,0.6],[0,0,0]]
		} else {
			[[0.5,0.4,1],[-0.5,0.4,1],[0,-0.6,0.8]]
		};
	private "_chute_temp";
	_chutePositionArray apply { 
		_chute_temp = createVehicle ["b_parachute_02_F",[0,0,0]]; 
		_chute_temp attachTo [_vehicleToDrop, (getCenterOfMass _vehicleToDrop) vectorAdd [0,0,1]]; 
		_chute_temp setVectorUp _x;
		_chutesArray pushBack _chute_temp; 
	};

	// wait to delete chutes and detach vehicle
	[
		1,
		{
			params ["_vehicleToDrop","_chutesArray"];
			// delete main chute
			detach _vehicleToDrop;
			deleteVehicle (_chutesArray deleteAt 0);

			// delete and detach fake chutes
			_chutesArray apply {
				detach _x;
				
				[
					{
						params ["_chute"];

						if !(isNull _chute) then {
							deleteVehicle _chute;
						};
					},
					[_x],
					10
				] call CBA_fnc_waitAndExecute;
			};

			// wait to mark DZ
			[
				{_this call KISKA_fnc_CD_markDropPosition},
				[_vehicleToDrop],
				10
			] call CBA_fnc_waitAndExecute
		},
		// wait till vehicle is at least 10 meters from the ground
		{(getPosATLVisual (_this select 0) select 2) < 5},
		[_vehicleToDrop,_chutesArray]
	] call KISKA_fnc_waitUntil;
};
/* ----------------------------------------------------------------------------


---------------------------------------------------------------------------- */
[
	{_this call KISKA_fnc_CD_deployChutes},
	[_vehicleToDrop,_isBackedIn],
	2.5
] call CBA_fnc_waitAndExecute;