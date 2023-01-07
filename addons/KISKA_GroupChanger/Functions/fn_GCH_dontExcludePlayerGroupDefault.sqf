/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_dontExcludePlayerGroupDefault

Description:
	In order to maintain a player-group-is-not-excluded by default in the 
	 Group Changer, when a player joins the game, they will set their group
	 to be not excluded on all other machines and JIP

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		POST-INIT Function
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_dontExcludePlayerGroupDefault";

if !(hasInterface) exitWith {};

private _playerGroup = group player;
if (isNull _playerGroup) exitWith {};

private _isGroupExcluded = [_playerGroup,true] call KISKA_fnc_GCH_isGroupExcluded;
private _exclusionWasSet = !(isNil "_isGroupExcluded");
if (_exclusionWasSet) exitWith {};

[_playerGroup,false,true] call KISKA_fnc_GCH_setGroupExcluded;


nil
