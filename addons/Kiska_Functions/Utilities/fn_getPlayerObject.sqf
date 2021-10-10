/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getPlayerObject

Description:
	Finds local player object.
	
	Why not use PLAYER? Issues seem to persist with eventhandlers such as "Killed" and "respawn" when simply using the PLAYER command
	Specifically, actions doubling onto players and/or not being prsent upon first respawn, but afterwards being present

Parameters:
	NONE

Returns:
	OBJECT

Examples:
    (begin example)
		call KISKA_fnc_getPlayerObject
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {objNull};

private _localPlayer = ((call BIS_fnc_listPlayers) select {local _x}) select 0;

_localPlayer