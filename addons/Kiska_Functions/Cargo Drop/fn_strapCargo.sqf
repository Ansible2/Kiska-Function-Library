/* ----------------------------------------------------------------------------
Function: KISKA_fnc_strapCargo

Description:
	Attaches one vehicle to another (should ideally be a player action)

Parameters:

	0: _vehicleToLoad <OBJECT> - ...
	1: _aircraftType <STRING> - The class of aircraft to strap to

Returns:
	NOTHING

Examples:
    (begin example)

		[_vehicleToLoad, "USAF_C17"] call KISKA_fnc_strapCargo;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */

params [
	["_vehicleToLoad",objNull,[objNull]],
	["_aircraftType","USAF_C17",[""]]
];

private _aircraft = nearestObject [_vehicleToLoad,_aircraftType];

[_vehicleToLoad,_aircraft,true] remoteExecCall ["BIS_fnc_attachToRelative",_vehicleToLoad];