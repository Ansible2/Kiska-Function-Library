/* ----------------------------------------------------------------------------
Function: KISKA_fnc_updateRallyPointNotification

Description:
	Informs the player that their rally point was updated

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		remoteExec ["KISKA_fnc_updateRallyPointNotification",somePlayer];
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_updateRallyPointNotification";

if (!hasInterface) exitWith {};

[["MESSAGE",1.1,[0.75,0,0,1]],"Rally Point Was Updated",false] call CBA_fnc_notify;


nil
