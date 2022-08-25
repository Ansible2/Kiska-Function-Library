/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_addGroupEventhandlers

Description:
	Adds group eventhandlers that help the GCH GUI function.

Parameters:
	0: _group <GROUP> - The Group to add the eventhandlers to

Returns:
	NOTHING

Examples:
    (begin example)
        [group player] call KISKA_fnc_GCH_addGroupEventhandlers
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_addGroupEventhandlers";

params [
	["_group",grpNull,[grpNull]]
];


if (isNull _group) exitWith {
	["Null group provided, exiting...",true] call KISKA_fnc_log;
	nil
};


private _id = _group addEventHandler ["GroupIdChanged", {
	params ["_group", "_newGroupId"];
	if !(isNull _group) then {
		private _selectedGroup = localNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];
		if (_group isEqualTo _selectedGroup) then {
			[false,false,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
		};

		[] call KISKA_fnc_GCH_updateSideGroupList;

	};
	
}];
private _id = _group addEventHandler ["LeaderChanged", {
	params ["_group", "_newLeader"];
}];
_group addEventHandler ["Empty", {
	params ["_group"];
}];
_group addEventHandler ["UnitLeft", {
	params ["_group", "_oldUnit"];
}];
_group addEventHandler ["UnitJoined", {
	params ["_group", "_newUnit"];
}];