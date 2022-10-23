/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_setGroupExcluded

Description:
	Sets a group's exclusion from the Group Changer.

Parameters:
	0: _group <GROUP> - The group to check exclusion of
	1: _isExcluded <BOOL> - True to exclude group, false to include

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

if !(hasInterface) exitWith {true};

params [
	["_group",grpNull,[grpNull]],
	["_isExcluded",true,[true]]
];

if (isNull _group) exitWith {
	["null group provided"] call KISKA_fnc_log;
	true
};


_group setVariable ["KISKA_GCH_exclude",_isExcluded];
[true] call KISKA_fnc_GCH_updateSideGroupsList;


_isExcluded