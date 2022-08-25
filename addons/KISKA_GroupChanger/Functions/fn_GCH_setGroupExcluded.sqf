/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_setGroupExcluded

Description:
	Sets a group's exclusion from the Group Changer.

Parameters:
	0: _group <GROUP> - The group to check exclusion of
	1: _isExcluded <BOOL> - True to exclude group, false to include
	2: _targets <BOOL, NUMBER, or ARRAY<NUMBER>> - setVariable targets, 
		(default to public JIP 'true')

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

params [
	["_group",grpNull,[grpNull]],
	["_isExcluded",true,[true]],
	["_targets",true,[123,true,[]]]
];

if (isNull _group) exitWith {
	["null group provided"] call KISKA_fnc_log;
	true
};


_group setVariable ["KISKA_GCH_exclude",_isExcluded,_targets];
_isExcluded

