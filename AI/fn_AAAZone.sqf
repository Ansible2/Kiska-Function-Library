/* ----------------------------------------------------------------------------
Function: KISKA_fnc_AAAZone

Description:
	Sets up a 

Parameters:
	0: _vehicle : <OBJECT> - The AAA piece

Returns:
	BOOL

Examples:
    (begin example)

		[myVehicle] call KISKA_fnc_AAAZone;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_vehicle",objNull,[objNull]]
];

if (isNull _vehicle) exitWith {
	"_vehicle isNull" call BIS_fnc_error;
};

if (isNull (gunner _vehicle)) exitWith {
	"_vehicle does not have a gunner" call BIS_fnc_error;
};

!((thisList findIf {(objectParent _x) isKindOf "air"}) isEqualTo -1)