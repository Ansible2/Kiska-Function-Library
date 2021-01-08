/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_isAllowedToEdit

Description:
	Checks if a machine is allowed to edit a given property in the GCH dialog.

Parameters:
	0: _groupLeader <OBJECT or GROUP> - The leader or group to edit the property on.
		If provided, it will be assumed that even the group leader can edit the property

Returns:
	<BOOL> - True if yes, false if no.

Examples:
    (begin example)
        _canEdit = [myGroup] call KISKA_fnc_GCH_isAllowedToEdit;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCH_isAllowedToEdit"
scriptName SCRIPT_NAME;

params [
	["_groupLeader",objNull,[objNull,grpNull]]
];

// hosts and admins can always edit
if (call KISKA_fnc_isHostOrAdmin) exitWith {
	true
};


if (_groupLeader isEqualType grpNull) then {
	_groupLeader = leader _groupLeader;
};

if (isNull _groupLeader) exitWith {
	false
};

if (local _groupLeader) then {
	true
} else {
	false
};