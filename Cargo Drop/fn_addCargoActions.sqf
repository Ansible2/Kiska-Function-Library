/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addCargoActions

Description:
	Adds the cargo drop actions to a vehicle to enable loading, unloading, and releasing for drop
	
	The action IDs are assigned per vehicle. ex. _vehicle getVariable "KISKA_cargoActions" would be an array formated as:
	[Strap Action ID, Unstrap Action ID, Release Action ID]

Parameters:
	0: _aircraftInfo <ARRAY> - An array formated as [class of aircraft (STRING), distance to activate actions (NUMBER)]. The aircraft is the type you want to be able to load into
 	1: _vehicles <OBJECT or ARRAY> - The vehicle to add the actions to

Returns:
	BOOL

Examples:
    (begin example)

		[['USAF_C17',15], _vehicle] call KISKA_fnc_addCargoActions;

    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {false};

params [
	["_aircraftInfo",['USAF_C17',15],[[]]],
	["_vehicles",objNull,[objNull,[]]]
];

// verify params
if !(_aircraftInfo isEqualTypeParams ["",123]) exitWith {
	"_aircraftInfo array is not proprer types" call BIS_fnc_error;
	false
};

if (_vehicles isEqualType [] AND {!(_vehicles isEqualTypeAll objNull)}) exitWith {
	"_vehicles array includes non-objects" call BIS_fnc_error;
	false
};

if (_vehicles isEqualType objNull AND {isNull _vehicles}) exitWith {
	"_vehicles isNull" call BIS_fnc_error;
	false
};

if (_vehicles isEqualType objNull) then {
	_vehicles = [_vehicles];
};


[_vehicles,_aircraftInfo] spawn {
	params [
		"_vehicles",
		"_aircraftInfo"
	];

	private _aircraftInfoString = str _aircraftInfo;

	_vehicles apply {

		if (alive _x) then {

			private _id1 = _x addAction [ 
				"--Strap Vehicle",  
				{
					private _vehicleToLoad = param [0,objNull,[objNull]];
					private _args = param [3,[],[[]]];

					["KISKA_cargoStrapped_Event",[_vehicleToLoad,_args select 0]] call CBA_fnc_serverEvent;
				}, 
				[_aircraftInfo select 0], 
				1.5,  
				false,  
				false,  
				"", 
				"(count (_target nearEntities " + _aircraftInfoString + ") > 0) AND {!(_target getVariable ['KISKA_CargoStrapped',false])}", 
				5, 
				false 
			];

			uiSleep 0.5;

			private _id2 = _x addAction [    
				"--Unstrap Vehicle",  
				{ 
					params ["_vehicleToUnLoad"]; 
					
					["KISKA_cargoUnstrapped_Event",[_vehicleToUnLoad]] call CBA_fnc_serverEvent;
				}, 
				[], 
				1.5,  
				false,  
				false,  
				"", 
				"_target getVariable ['KISKA_CargoStrapped',false] AND {!((getPosATL _target select 2) > 20)}", 
				5, 
				false 
			];

			uiSleep 0.5;

			private _id3 = _x addAction [ 
				"--Release Vehicle",  
				{ 
					params ["_vehicleToUnLoad"]; 
						
					["KISKA_cargoDrop_Event",[_vehicleToUnLoad]] call CBA_fnc_serverEvent;
				}, 
				[], 
				2,  
				false,  
				false,  
				"", 
				"_target getVariable ['KISKA_CargoStrapped',false] AND {(getPosATL _target select 2) > 10}", 
				7, 
				false 
			];

			_x setVariable ["KISKA_cargoActions",[_id1,_id2,_id3]];

			uiSleep 0.5;

		};
	};
};


true