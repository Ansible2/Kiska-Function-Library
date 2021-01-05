// give the group an ability to rally
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