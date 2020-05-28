/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addUnloadCratesAction

Description:
	Adds unload action to vehicle when crate is initially loaded

Parameters:

	0: _vehicle <OBJECT> - The vehicle to add the action to

Returns:
	BOOL

Examples:
    (begin example)

		[vehicle1] call KISKA_fnc_addUnloadCratesAction;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_vehicle",objNull,[objNull]]
];

if (isNull _vehicle) exitWith {
	"_vehicle isNull" call BIS_fnc_error;
	false
};

private _unloadActionID = _vehicle addAction [
	"--Unload Crate(s)",
	{
		hint "Unloaded";

		params ["_vehicle"];

		private _attachedCrates = attachedObjects _vehicle; // this needs to be filtered eventually

		{
			detach _x;

			_x setPosATL (_vehicle getRelPos [([_vehicle,1] call KISKA_fnc_getVehicleInfo) + (_forEachindex * 1.75),180]);

			_x setVariable ["DSO_crateLoaded",false,true];

		} forEach _attachedCrates;

		_vehicle removeAction (_this select 2);

		_vehicle setVariable ["DSO_numCratesLoaded",0,true];

		[_vehicle] remoteExecCall ["KISKA_fnc_removeUnloadAction",call CBA_fnc_players,true];
	},
	[],
	10,
	true,
	true,
	"",
	"isNull (objectParent _this)",
	[_vehicle,4] call KISKA_fnc_getVehicleInfo
];

_vehicle setVariable ["DSO_unloadActionID",_unloadActionID];

true