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
		Initialized by KISKA_fnc_initializeRespawnSystem
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */


if !(isMultiplayer) exitWith {};

params [
	["_caller",objNull,[objNull]],
	["_marker","",[""]],
	["_markerText","",[""]]
];

// construct the variable string to use on BIS_fnc_removeRespawnPosition
private _varString = (_markerText + "ID");

if !(isNil _varString) then {
	(missionNamespace getVariable _varString) call BIS_fnc_removeRespawnPosition;
};

private _id = [missionNamespace, getposATL _caller, _markerText] call BIS_fnc_addRespawnPosition;

// set the varstring constructed above to the value of the id so it can be used later when the postion is removed and another created
missionNamespace setVariable [_varString,_id];

// check if marker is created already
if (getMarkerType _marker isEqualTo "") then {
	(["|",_marker,"|",str (getPosATL _caller),"|respawn_inf|ICON|[1,1]|0|Solid|","color",str (side _caller),"|1|",_markerText] joinString "") call BIS_fnc_stringToMarker;
} else {
	_marker setMarkerPos _caller;
};