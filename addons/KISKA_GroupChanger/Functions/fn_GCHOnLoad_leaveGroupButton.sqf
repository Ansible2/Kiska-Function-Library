/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_leaveGroupButton

Description:
	The function that fires on the leave group button click event.
	The Event is added in KISKA_fnc_GCHOnLoad.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        call KISKA_fnc_GCH_leaveGroupButton;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCH_leaveGroupButton";

if !(hasInterface) exitWith {};

params ["_control"];

_control ctrlAddEventHandler ["ButtonClick",{
	private _playerSide = [] call KISKA_fnc_GCH_getPlayerSide;
	private _newGroup = createGroup [_playerSide, true];
	[player] joinSilent _newGroup;
}];


nil
