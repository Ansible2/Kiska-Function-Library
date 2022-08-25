/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_isGroupExcluded

Description:
	Checks if a group is excluded from the Group Changer menu.

Parameters:
	0: _group <GROUP> - The group to check exclusion of

Returns:
	<BOOL> - Returns true if the group is excluded or false if not

Examples:
    (begin example)
        private _isExcluded = [group player] call KISKA_fnc_GCH_isGroupExcluded;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_isGroupExcluded";

params [
	["_group",grpNull,[grpNull]]
];


_group getVariable ["KISKA_GCH_exclude",true];

