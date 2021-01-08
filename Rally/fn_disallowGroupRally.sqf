/* ----------------------------------------------------------------------------
Function: KISKA_fnc_disallowGroupRally

Description:
	Removes a group from the KISKA_rallyAllowedGroups array on the server which allows
	 its members to place down rally points.

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
	[SCRIPT_NAME,"Needs to be run on the server",false,true,true] call KISKA_fnc_log;

	false
};

params [
	["_groupToRemove",grpNull,[objNull,grpNull]],
	["_deleteMarker",true,[true]]
];

private _allowedGroups = missionNamespace getVariable ["KISKA_rallyAllowedGroups",[]];
if (_allowedGroups isEqualTo []) exitWith {
	true
};

_groupToRemove = [_groupToRemove] call CBA_fnc_getGroup;

if (isNull _groupToRemove) exitWith {
	[SCRIPT_NAME,"_groupToRemove was null",false,true,true] call KISKA_fnc_log;

	false
};

private _index = _allowedGroups findIf {
	_x isEqualTo _groupToRemove
};

if (_index isEqualTo -1) exitWith {
	true
};

_allowedGroups deleteAt _index;


if (_deleteMarker) then {
	private _markerID = _groupToRemove getVariable ["KISKA_groupRespawnMarkerID",[]];
	// if marker ID exitsts
	if !(_markerID isEqualTo []) then {
		private _marker = _groupToRemove getVariable "KISKA_groupRespawnMarker";
		[SCRIPT_NAME,["Found marker id",_markerID,"for group",_groupToRemove,"---Will remove marker",_marker]] call KISKA_fnc_log;
		
		_markerID call BIS_fnc_removeRespawnPosition;
		deleteMarker _marker;

		_groupToRemove setVariable ["KISKA_groupRespawnMarker",nil];
		_groupToRemove setVariable ["KISKA_groupRespawnMarkerID",nil];
	};
};


true