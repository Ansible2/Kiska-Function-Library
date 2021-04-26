/* ----------------------------------------------------------------------------
Function: KISKA_fnc_updateRespawnMarker

Description:
	Deletes the old respawn marker and makes a new one.

Parameters:
	0: _caller <OBJECT> - The person calling the respawn update action
	1: _marker <MARKER/STRING> - The old marker to delete
	2: _markerText <STRING> - The text of the new marker

Returns:
	NOTHING

Examples:
    (begin example)
		[player,myMarker,myMarkerText] call KISKA_fnc_updateRespawnMarker;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_updateRespawnMarker";

if !(isMultiplayer) exitWith {};

params [
	["_caller",objNull,[objNull]],
	["_marker","",[""]],
	["_markerText","",[""]]
];

private _callerGroup = group _caller;
if !([_callerGroup] call KISKA_fnc_isGroupRallyAllowed) exitWith {
	[["Got marker request for ",_callerGroup," --- Did not create marker"],true] call KISKA_fnc_log;
	["Your group is not registered to allow for rally points"] remoteExecCall ["hint",_caller];
};

private _markerID = _callerGroup getVariable ["KISKA_groupRespawnMarkerID",[]];
// if the group already has a rally point down, get rid of it before making a new one
if !(_markerID isEqualTo []) then {
	[["Existing Marker ID for group: ",_callerGroup," was found. Marker ID is: ",_markerID," ... Execing BIS_fnc_removeRespawnPosition"],false] call KISKA_fnc_log;

	// delete map marker
	private _currentMarker = (_callerGroup getVariable "KISKA_groupRespawnMarker");
	[["Deleteing current marker for ",_callerGroup," which is named: ",_currentMarker],false] call KISKA_fnc_log;
	deleteMarker _currentMarker;

	// remove respawn position
	private _wasRemoved = (_callerGroup getVariable "KISKA_groupRespawnMarkerID") call BIS_fnc_removeRespawnPosition;
	[["Was the old respawn position removed? ",_wasRemoved],false] call KISKA_fnc_log;
};

private _position = ASLToAGL (getPosASL _caller);
private _id = [missionNamespace,_position, _markerText] call BIS_fnc_addRespawnPosition;
[["Adding respawn position to ",_position,"--- Marker ID is", _id],false] call KISKA_fnc_log;

// set id to be used in this function in the future
_callerGroup setVariable ["KISKA_groupRespawnMarkerID",_id];

// check if marker is created already
if (getMarkerType _marker isEqualTo "") then {
	(["|",_marker,"|",_position,"|respawn_inf|ICON|[1,1]|0|Solid|","color",(side _caller),"|1|",_markerText] joinString "") call BIS_fnc_stringToMarker;

	_callerGroup setVariable ["KISKA_groupRespawnMarker",_marker];
	[["Created marker ",_marker],false] call KISKA_fnc_log;

} else {
	_marker setMarkerPos _caller;
	[["Changed marker ",_marker," position"],false] call KISKA_fnc_log;
};

// send update message back to caller
remoteExec ["KISKA_fnc_updateRallyPointNotification",_caller];
