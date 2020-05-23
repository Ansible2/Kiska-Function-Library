/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setCrew

Description:
	Moves units into a vehicle as crew and then as passengers.

Parameters:
	0: _crew : <GROUP or ARRAY> - The units to move into the vehicle
	1: _vehicle : <OBJECT> - The vehicle to put units into

Returns:
	Nothing

Examples:
    (begin example)

		null = [_group1, _vehicle] spawn KISKA_fnc_setCrew;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_crew",grpNull,[[],grpNull]],
	["_vehicle",objNull,[objNull]]
];

if (_crew isEqualType grpNull) then {_crew = units _crew};

if (_crew isEqualTo []) exitWith {};

if (isNull _vehicle OR {!(alive _vehicle)}) exitWith {
	_crew apply {
		deleteVehicle _x;
	};
};

_crew apply {
	private _movedIn = _x moveInAny _vehicle;

	if !(_movedIn) then {deleteVehicle _x};
};