// check if a group can rally
#define SCRIPT_NAME "KISKA_fnc_isGroupRallyAllowed"
scriptName SCRIPT_NAME;

if !(isServer) exitWith {
	[SCRIPT_NAME,"Needs to be run on server for proper returns",false,true] call KISKA_fnc_log;

	false
};

params [
	["_groupToCheck",grpNull,[objNull,grpNull]]
];

_groupToCheck = [_groupToCheck] call CBA_fnc_getGroup;

if (isNull _groupToCheck) exitWith {
	[SCRIPT_NAME,"_groupToCheck was null",false,true] call KISKA_fnc_log;

	false
};

private _isRallyAllowed = [
	missionNamespace getVariable ["KISKA_rallyAllowedGroups",[]],
	{
		_x isEqualTo (_thisArgs select 0);
	},
	[_groupToCheck]
] call KISKA_fnc_findIfBool;


_isRallyAllowed