/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_addMissionEvents

Description:
	Adds mission event handlers for keeping track of groups.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        PRE-INIT function
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_addMissionEvents";

if !(hasInterface) exitWith {};

if (call KISKA_fnc_isMainMenu) exitWith {
	["Main menu detected, will not init",false] call KISKA_fnc_log;
	nil
};


addMissionEventHandler ["GroupCreated", {
	params ["_group"];
	// TODO: Make this more reliable with waiting until the group has units
	// Need to also check that the group does not already have KISKA_GCH_exclude set
	/// before determining this from the value
	// Also make sure that KISKA_fnc_GCH_updateSideGroupsList is only called (or not)
	/// after these verifications.
	_this spawn {
		params ["_group"];
		sleep 3;

		private _units = units _group;
		private _playerInGroup = [
			_units,
			{isPlayer _x}
		] call KISKA_fnc_findIfBool;

		_group setVariable ["KISKA_GCH_exclude", !(_playerInGroup)];
	};

	private _groupChangerOpen = [] call KISKA_fnc_GCH_isOpen;
    if (_groupChangerOpen) then {
        [] call KISKA_fnc_GCH_updateSideGroupsList;
    };
}];


addMissionEventHandler ["GroupDeleted", {
	private _groupChangerOpen = [] call KISKA_fnc_GCH_isOpen;
    if (_groupChangerOpen) then {
        [] call KISKA_fnc_GCH_updateSideGroupsList;
    };
}];


nil
