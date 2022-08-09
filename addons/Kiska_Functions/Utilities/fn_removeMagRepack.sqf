/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addMagRepack

Description:
	Adds a mag repack to the player via Ctrl+R.
	To remove see KISKA_fnc_removeMagRepack.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_addMagRepack;
    (end)

Author(s):
	Quicksilver,
	Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_removeMagRepack";

#define DISPLAY_CODE 46

if (!hasInterface) exitWith {};

if (localNamespace getVariable ["KISKA_magRepackEventId",-1] isEqualTo -1) exitWith {
	["Mag repack was not present"] call KISKA_fnc_log;
	nil
};

[
	{
		!(isNull (findDisplay DISPLAY_CODE))
	},
	{
        private _eventId = localNamespace getVariable ["KISKA_magRepackEventId",-1];
		// possibility of two mag repack waitUntils runnning at once
		if (_eventId isEqualTo -1) exitWith {
			["Mag repack was already removed never added"] call KISKA_fnc_log;
			nil
		};

		(findDisplay DISPLAY_CODE) displayRemoveEventHandler ["KeyDown", _eventId];
		localNamespace setVariable ["KISKA_magRepackEventId",nil];
	},
	0
] call KISKA_fnc_waitUntil;


nil
