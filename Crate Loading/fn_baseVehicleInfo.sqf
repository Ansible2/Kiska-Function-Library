/* ----------------------------------------------------------------------------
Function: KISKA_fnc_baseVehicleInfo

Description:
	Creates the basic globals for crate loading.
	
	To add vehicle support:
		1. Add the vehicle type to the DSO_vehicleTypes array
		2. Create a global Array of the specfic vehicles information formatted as:
			- Name of the array needs to be 'DSOInfo_' plus the vehicle's type (see below for examples)
				0: crate z offset
					- Used to get crates at the right height in the vehicle
				1: unload offset
					- When unloading the crates, how far back should the crates be dropped
				2: crate y offset
					- This is used to determine the initial starting point for the first crate loaded
				3: Max Crates
					- What is the max number of crates the vehicle can hold
				4: Unload action distance
					- simply how far away you want the unload action to appear from a vehicle

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)

		call KISKA_fnc_baseVehicleInfo;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

DSO_vehicleTypes = [
	"Truck_01_base_F",
	"Heli_Transport_03_base_F",
	"I_Heli_Transport_02_F"
];

DSOInfo_Truck_01_base_F = [
	0.5, 	// crate z offset
	7,    	// unload offset	
	0.5, 	// crate y offset
	3,    	// max crates
	8   	// unload action distance
];

DSOInfo_Heli_Transport_03_base_F = [
	2.15,	// crate z offset
	8,   	// unload offset	
	1.85, 	// crate y offset
	4,   	// max crates
	10   	// unload action distance
];

DSOInfo_I_Heli_Transport_02_F = [
	2.25, 
	11, 
	4.5, 
	5, 
	10 
];