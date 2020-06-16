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
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_vehicleToDrop",objNull,[objNull]]
];

if (isNull _vehicleToDrop) exitWith {};

private _aircraftLoadedIn = attachedTo _vehicleToDrop;

_vehicleToDrop disableCollisionWith _aircraftLoadedIn;

detach _vehicleToDrop;

[_vehicleToDrop,false] remoteExecCall ["allowDamage",_vehicleToDrop];

[_vehicleToDrop,true] remoteExecCall ["enableSimulationGlobal",2];

if (dynamicSimulationSystemEnabled AND {dynamicSimulationEnabled _vehicleToDrop}) then {
	[_vehicleToDrop,false] remoteExec ["enableDynamicSimulation",2];
};

private _relativeFront = ((0 boundingBox _aircraftLoadedIn) select 1) select 1;

private _frontOfAircraftPosition = _aircraftLoadedIn modelToWorld [0,_relativeFront,0];

private _relativeDirection = _vehicleToDrop getRelDir _frontOfAircraftPosition;

private _isBackedIn = if (_relativeDirection > 10 AND {_relativeDirection < 350}) then {true} else {false}; 

[_vehicleToDrop,[0,[-40,40] select _isBackedIn,2]] remoteExecCall ["setVelocityModelSpace",_vehicleToDrop];

_vehicleToLoad setVariable ["KISKA_CargoStrapped",false,true];


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


[
	{
		params [
			["_vehicleToDrop",objNull,[objNull]],
			["_isBackedIn",false,[true]]
		];

		private _chutesArray = [];

		private _chutePositionArray = if (getMass _vehicleToDrop > 10000) then {
				[[0.5,0.4,0.6],[-0.5,0.4,0.6],[0.5,-0.4,0.6],[-0.5,-0.4,0.6],[0,0,0]]
			} else {
				[[0.5,0.4,1],[-0.5,0.4,1],[0,-0.6,0.8]]
			};

		_chutePositionArray apply { 
			private _parachute = createVehicle ["b_parachute_02_F",[0,0,0]]; 
				
			_parachute attachTo [_vehicleToDrop, (getCenterOfMass _vehicleToDrop) vectorAdd [0,0,1]]; 
			_parachute setVectorUp _x;

			_chutesArray pushBack _parachute; 
		};

		_vehicleToDrop setVariable ["Kiska_dropChutes",_chutesArray,owner _vehicleToDrop];

		private _randomWindDriftY = random [-15,0,15];
		private _randomWindDriftX = random [20,25,30];

		[
			{
				private _vehicleToDrop = (_this getVariable "params") select 0;
				private _isBackedIn = (_this getVariable "params") select 2;
				private _randomWindDriftY = (_this getVariable "params") select 3;
				private _randomWindDriftX = (_this getVariable "params") select 4;
				private _vehicleAlt = getPosATLVisual _vehicleToDrop select 2;

				if (_vehicleAlt > 1500) then {
					[_vehicleToDrop,[_randomWindDriftY,[-_randomWindDriftX,_randomWindDriftX] select _isBackedIn,-70]] remoteExecCall ["setVelocityModelSpace",_vehicleToDrop];
				} else {
					[_vehicleToDrop,[_randomWindDriftY,[-_randomWindDriftX,_randomWindDriftX] select _isBackedIn,-35]] remoteExecCall ["setVelocityModelSpace",_vehicleToDrop];
				};

			},
			0.5,
			[_vehicleToDrop,_chutesArray,_isBackedIn,_randomWindDriftY,_randomWindDriftX],
			{},
			{
				((_this getVariable "params") select 1) apply {
					detach _x;
					
					[
						{
							params [
								["_chute",objNull,[objNull]]
							];

							if !(isNull _chute) then {
								deleteVehicle _chute;
							};
						},
						[_x],
						10
					] call CBA_fnc_waitAndExecute;
				};

				private _vehicleToDrop = (_this getVariable "params") select 0;
				[
					{
						params ["_vehicleToDrop"];

						private _position = [_vehicleToDrop,15] call CBA_fnc_randPos;
						
						private _chemlight = createvehicle ["Chemlight_green_infinite",_position,[],0,"NONE"];
						private _smoke = createvehicle ["G_40mm_SmokeBlue_infinite",_position,[],0,"NONE"];
						private _flare = createvehicle ["F_40mm_Red",_position,[],0,"NONE"];

						[
							2,
							{
								params [
									"_vehicleToDrop",
									"_chemlight",
									"_smoke"
								];

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
								params ["_vehicleToDrop"];
								!(((call CBA_fnc_players) findIf {(_x distance2D _vehicleToDrop) < 10}) isEqualTo -1)
							},
							[_vehicleToDrop,_chemlight,_smoke]
						] call KISKA_fnc_waitUntil;
					},
					[_vehicleToDrop],
					10
				] call CBA_fnc_waitAndExecute;
				
			},
			{
				(velocityModelSpace ((_this getVariable "params") select 0) select 2 ) < -25
			},
			{
				(getPosATLVisual ((_this getVariable "params") select 0)) select 2 < 10
			}
		] call CBA_fnc_createPerFrameHandlerObject;		

	},
	[_vehicleToDrop,_isBackedIn],
	2.5
] call CBA_fnc_waitAndExecute;