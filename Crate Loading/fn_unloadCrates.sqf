/* ----------------------------------------------------------------------------
Function: KISKA_fnc_unloadCrates

Description:
	Unloads the crates from vehicle.

Parameters:

	0: _vehicle <OBJECT> - The vehicle to unload crates from

Returns:
	BOOL

Examples:
    (begin example)

		[vehicle1] call KISKA_fnc_unloadCrates;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_vehicle",objNull,[objNull]]
];

private _attachedCrates = _vehicle getVariable ["DSO_loadedCrates",[]];

if (_attachedCrates isEqualTo []) exitWith {
	hint "No crates to unload";
	false
};

{
	detach _x;

	_x setPosATL (_vehicle getRelPos [([_vehicle,1] call KISKA_fnc_getVehicleInfo) + (_forEachindex * 1.75),180]);

	_x setVariable ["DSO_crateLoaded",false,true];

} forEach _attachedCrates;

hint "Unloaded";

_vehicle removeAction (_this select 2);

_vehicle setVariable ["DSO_loadedCrates",[],true];

[_vehicle] remoteExecCall ["KISKA_fnc_removeUnloadAction",call CBA_fnc_players,true];

true