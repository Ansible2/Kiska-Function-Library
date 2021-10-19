/* ----------------------------------------------------------------------------
Function: KISKA_fnc_isGroupRallyAllowed

Description:
	Checks if a group is has KISKA_canRally saved to its namespace on the server
	 which allows its members to place down rally points.

Parameters:
	0: _groupToCheck <GROUP or OBJECT> - The group or the unit whose group you want to check

Returns:
	<BOOL> - True if allowed, false if not or error

Examples:
    (begin example)
		// checks if player's group can use the rally system (if they're the server)
		[player] call KISKA_fnc_isGroupRallyAllowed;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_isGroupRallyAllowed";

if !(isServer) exitWith {
	["Needs to be run on server for proper returns",true] call KISKA_fnc_log;
	false
};

params [
	["_groupToCheck",grpNull,[objNull,grpNull]]
];

_groupToCheck = [_groupToCheck] call CBA_fnc_getGroup;

if (isNull _groupToCheck) exitWith {
	["_groupToCheck was null",true] call KISKA_fnc_log;
	false
};

private _isRallyAllowed = _groupToCheck getVariable ["KISKA_canRally",false];


_isRallyAllowed
