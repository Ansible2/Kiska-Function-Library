/* ----------------------------------------------------------------------------
Function: KISKA_fnc_removeUnloadAction

Description:
	Removes the unload action from vehicles (to save performance)

Parameters:

	0: _vehicle <OBJECT> - The vehicle to remove the action from

Returns:
	BOOL

Examples:
    (begin example)
		[vehicle1] call KISKA_fnc_removeUnloadAction;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

params [
	["_vehicle",objNull,[objNull]]
];

if (isNil {_vehicle getVariable "DSO_unloadActionID"}) exitWith {false};

_vehicle removeAction (_vehicle getVariable "DSO_unloadActionID");

true
