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
	Ansible2
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

	if (local _vehicle AND {local _x}) then {
		_vehicle disableCollisionWith _x;
	} else {
		[_vehicle,_x] remoteExecCall ["disableCollisionWith",[_x,_vehicle]];
	};

	_x setPosATL (_vehicle getRelPos [([_vehicle,1] call KISKA_fnc_getVehicleInfo) + (_forEachindex * 1.75),180]);

	_x setVariable ["DSO_crateLoaded",false,true];

} forEach _attachedCrates;

hint "Unloaded";

_vehicle removeAction (_vehicle getVariable "DSO_unloadActionID");

_vehicle setVariable ["DSO_loadedCrates",[],true];

[_vehicle] remoteExecCall ["KISKA_fnc_removeUnloadAction",0,true];

true
