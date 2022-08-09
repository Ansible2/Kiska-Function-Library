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
scriptName "KISKA_fnc_addMagRepack";

#define DISPLAY_CODE 46
#define R_KEY_CODE 19

if (!hasInterface) exitWith {};

if (localNamespace getVariable ["KISKA_magRepackEventId",-1] isNotEqualTo -1) exitWith {
	["Mag repack has already been added",true] call KISKA_fnc_log;
	nil
};

[
	{
		!(isNull (findDisplay DISPLAY_CODE))
	},
	{
		// possibility of two mag repack waitUntils runnning at once
		if (localNamespace getVariable ["KISKA_magRepackEventId",-1] isNotEqualTo -1) exitWith {
			["Mag repack has already been added",true] call KISKA_fnc_log;
			nil
		};

		private _eventId = (findDisplay DISPLAY_CODE) displayAddEventHandler ["KeyDown",{
			params ["", "_key", "", "_ctrlPressed"];
			// passes the pressed key and whether or not a ctrl key is down. The proper combo is ctrl+R
			if ((_key isEqualTo R_KEY_CODE) AND (_ctrlPressed)) then {
				[player] call KISKA_fnc_doMagRepack;
			};

			false
		}];

		localNamespace setVariable ["KISKA_magRepackEventId",_eventId];
	},
	0.1
] call KISKA_fnc_waitUntil;


nil
