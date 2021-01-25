/* ----------------------------------------------------------------------------
Function: KISKA_fnc_disallowGroupRally

Description:
	Removes a groups ability to rally an deletes its marker if requested.

Parameters:
	0: _groupToRemove <GROUP or OBJECT> - The group or the unit whose group to remove
	1: _deleteMarker <BOOL> - Should the group's latest rally marker (if present) be deleted

Returns:
	<BOOL> - True if no longer allowed or never was, false if error

Examples:
    (begin example)
		// disallows player's group to drop a rally point (if they're the server)
		[player] call KISKA_fnc_disallowGroupRally;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_disallowGroupRally"
scriptName SCRIPT_NAME;

if !(isServer) exitWith {
	["Needs to be run on the server",true] call KISKA_fnc_log;

	false
};

params [
	["_groupToRemove",grpNull,[objNull,grpNull]],
	["_deleteMarker",true,[true]]
];

_groupToRemove = [_groupToRemove] call CBA_fnc_getGroup;

if (isNull _groupToRemove) exitWith {
	["_groupToRemove was null",true] call KISKA_fnc_log;

	false
};

_groupToRemove setVariable ["KISKA_canRally",false];

if (_deleteMarker) then {
	private _markerID = _groupToRemove getVariable ["KISKA_groupRespawnMarkerID",[]];
	// if marker ID exitsts
	if !(_markerID isEqualTo []) then {
		private _marker = _groupToRemove getVariable "KISKA_groupRespawnMarker";
		[["Found marker id ",_markerID," for group ",_groupToRemove," ---Will remove marker ",_marker],false] call KISKA_fnc_log;
		
		_markerID call BIS_fnc_removeRespawnPosition;
		deleteMarker _marker;

		_groupToRemove setVariable ["KISKA_groupRespawnMarker",nil];
		_groupToRemove setVariable ["KISKA_groupRespawnMarkerID",nil];
	};
};


true