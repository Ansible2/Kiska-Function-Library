/* ----------------------------------------------------------------------------
Function: KISKA_fnc_driveTo

Description:
	Units will drive to point and get out of vehicle

Parameters:
	0: _crew : <GROUP, ARRAY, or OBJECT> - The units to move into the vehicle and drive
	1: _vehicle : <OBJECT> - The vehicle to put units into
	2: _dismountPoint : <OBJECT or ARRAY> - The position to move to, can be object or position array

Returns:
	Nothing

Examples:
    (begin example)

		[_group1, _vehicle, myDismountLogic] call KISKA_fnc_driveTo;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */