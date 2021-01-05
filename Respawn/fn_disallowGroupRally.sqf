// remove a group's ability to rally
#define SCRIPT_NAME "KISKA_fnc_disallowGroupRally"
scriptName SCRIPT_NAME;

if !(isServer) exitWith {
	[SCRIPT_NAME,"Needs to be run on the server",false,true] call KISKA_fnc_log;

	false
};

params [
	["_groupToRemove",grpNull,[objNull,grpNull]]
];

private _allowedGroups = missionNamespace getVariable ["KISKA_rallyAllowedGroups",[]];
if (_allowedGroups isEqualTo []) exitWith {
	true
};

_groupToRemove = [_groupToRemove] call CBA_fnc_getGroup;

if (isNull _groupToRemove) exitWith {
	[SCRIPT_NAME,"_groupToRemove was null",false,true] call KISKA_fnc_log;

	false
};

private _index = _allowedGroups findIf {
	_x isEqualTo _groupToRemove
};

if (_index isEqualTo -1) exitWith {
	true
};

_allowedGroups deleteAt _index;


true