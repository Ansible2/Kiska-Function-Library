/* ----------------------------------------------------------------------------
Function: KISKA_fnc_allowGroupRally

Description:
	Adds group to the KISKA_rallyAllowedGroups array on the server which allows
	 its members to place down rally points.

Parameters:
	0: _groupToAdd <GROUP or OBJECT> - The group or the unit whose group to add

Returns:
	<BOOL> - True if allowed, false if not allowed or error

Examples:
    (begin example)
		// allows player's group to drop a rally point (if they're the server)
		[player] call KISKA_fnc_allowGroupRally;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_allowGroupRally"
scriptName SCRIPT_NAME;

if !(isServer) exitWith {
	[SCRIPT_NAME,"Needs to be run on the server",false,true] call KISKA_fnc_log;

	false
};

params [
	["_groupToAdd",grpNull,[objNull,grpNull]]
];

_groupToAdd = [_groupToAdd] call CBA_fnc_getGroup;

if (isNull _groupToAdd) exitWith {
	[SCRIPT_NAME,"_groupToAdd was null",false,true] call KISKA_fnc_log;

	false
};

private _allowedGroups = missionNamespace getVariable ["KISKA_rallyAllowedGroups",[]];
_allowedGroups pushBackUnique _groupToAdd;
missionNamespace setVariable ["KISKA_rallyAllowedGroups",_allowedGroups];


true