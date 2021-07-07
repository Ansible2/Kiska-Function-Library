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
	Ansible2
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

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
		[_this select 0] call KISKA_fnc_unloadCrates;
	},
	nil,
	10,
	true,
	true,
	"",
	"isNull (objectParent _this)",
	[_vehicle,4] call KISKA_fnc_getVehicleInfo
];

_vehicle setVariable ["DSO_unloadActionID",_unloadActionID];

true
