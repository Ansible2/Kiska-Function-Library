/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_setGroupExcluded

Description:
	Sets a group's exclusion from the Group Changer.

Parameters:
	0: _group <GROUP> - The group to check exclusion of
	1: _isExcluded <BOOL> - True to exclude group, false to include
	1: _synchronize <BOOL> - True to remoteExec this function and provide a JIP message

Returns:
	<BOOL> - Returns true if the group is excluded or false if not

Examples:
    (begin example)
		// exclude group
        private _isExcluded = [group player,true] call KISKA_fnc_GCH_setGroupExcluded;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_setGroupExcluded";

if (!hasInterface) exitWith {true};

params [
	["_group",grpNull,[grpNull]],
	["_isExcluded",true,[true]],
	["_synchronize",false,[true]]
];


if (isNull _group) exitWith {
	["null group provided"] call KISKA_fnc_log;
	true
};

if (_synchronize) exitWith {
	private _jipId = "KISKA_GCH_groupExclusion:" + (str _group);
	[_group,_isExcluded] remoteExecCall ["KISKA_fnc_GCH_setGroupExcluded",0,_jipId];
};

_group setVariable ["KISKA_GCH_exclude",_isExcluded];
[true] call KISKA_fnc_GCH_updateSideGroupsList;


_isExcluded
