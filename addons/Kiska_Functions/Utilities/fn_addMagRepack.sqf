/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addMagRepack

Description:
	Add mag repack to player via Ctrl+R

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
// check if has interface
// wait for display
// add mag repeack eventhandler
// add the eventhandler id to a variable in the localNamespace (or uiNamespace?)
waituntil {!isNull (findDisplay 46)};

(findDisplay 46) displayAddEventHandler ["KeyDown",{

	// passes the pressed key and whether or not a ctrl key is down. The proper combo is ctrl+R
	if ((_this select 1) isEqualTo 19 AND {_this select 3}) exitWith {
		[player] call KISKA_fnc_doMagRepack;
	};
}];
