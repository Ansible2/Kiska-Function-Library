/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addCargoEvents

Description:
	A postInit function to create the required CBA events for KISKA's cargo drop functions

Parameters:
	NONE

Returns:
	NONE

Examples:
    N/A

Author(s):
	Ansible2
---------------------------------------------------------------------------- */

// Strap Cargo
[
	"KISKA_cargoStrapped_Event",
	{
		params [
			["_vehicle",objNull,[objNull]],
			["_aircraftType","USAF_C17",[""]]
		];

		[_vehicle,_aircraftType] remoteExecCall ["KISKA_fnc_strapCargo",_vehicle];
		
		["OMLightSwitch",getPosASL _vehicle,50,5] call KISKA_fnc_playSound3D;

		_vehicle setVariable ["KISKA_CargoStrapped",true,[0,-2] select (isDedicated)]; 
	}
] call CBA_fnc_addEventHandler;

// unstrap cargo
[
	"KISKA_cargoUnstrapped_Event",
	{
		params [
			["_vehicle",objNull,[objNull]]
		];
		
		detach _vehicle;

		["OMLightSwitch",getPosASL _vehicle,50,5,false,0.1] call KISKA_fnc_playSound3D;

		_vehicle setVariable ["KISKA_CargoStrapped",false,[0,-2] select (isDedicated)]; 	
	}
] call CBA_fnc_addEventHandler;

// Cargo Drop event
[
	"KISKA_cargoDrop_Event",
	{
		params [
			["_vehicle",objNull,[objNull]]
		];
		
		[_vehicle] remoteExecCall ["KISKA_fnc_CargoDrop",_vehicle];
		_vehicle setVariable ["KISKA_CargoStrapped",false,[0,-2] select (isDedicated)]; 	
	}
] call CBA_fnc_addEventHandler;