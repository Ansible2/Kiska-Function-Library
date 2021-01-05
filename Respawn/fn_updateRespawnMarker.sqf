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
#define SCRIPT_NAME "KISKA_fnc_updateRespawnMarker"
scriptName SCRIPT_NAME;

if !(isMultiplayer) exitWith {};

params [
	["_caller",objNull,[objNull]],
	["_marker","",[""]],
	["_markerText","",[""]]
];

if !([group _caller] call KISKA_fnc_isGroupRallyAllowed) exitWith {
	[SCRIPT_NAME,["Got marker request for",group _caller,"--- Did not create marker"]] call KISKA_fnc_log;
	["Your group is not registered to allow for rally points"] remoteExecCall ["hint",_caller];
};

// construct the variable string to use on BIS_fnc_removeRespawnPosition
private _varString = (_markerText + "ID");

if !(isNil _varString) then {
	[SCRIPT_NAME,[_varString,"was found not to be nil. Execing BIS_fnc_removeRespawnPosition"]] call KISKA_fnc_log;
	(missionNamespace getVariable _varString) call BIS_fnc_removeRespawnPosition;
};

private _position = ASLToAGL (getPosASL _caller);
private _id = [missionNamespace,_position, _markerText] call BIS_fnc_addRespawnPosition;
[SCRIPT_NAME,["Adding respawn position to",_position,"--- Marker ID is", _id]] call KISKA_fnc_log;

// set the varstring constructed above to the value of the id so it can be used later when the postion is removed and another created
missionNamespace setVariable [_varString,_id];

// check if marker is created already
if (getMarkerType _marker isEqualTo "") then {
	(["|",_marker,"|",_position,"|respawn_inf|ICON|[1,1]|0|Solid|","color",(side _caller),"|1|",_markerText] joinString "") call BIS_fnc_stringToMarker;
	
	[SCRIPT_NAME,["Created marker",_marker]] call KISKA_fnc_log;
} else {
	_marker setMarkerPos _caller;
	[SCRIPT_NAME,["Changed marker",_marker,"position"]] call KISKA_fnc_log;
};

// send update message back to caller
["Rally Point Updated"] remoteExecCall ["hint",_caller];