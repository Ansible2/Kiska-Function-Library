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

private _eventMap = _group getVariable "KISKA_GCH_groupEventIdMap";
if !(isNil "_eventMap") exitWith {
	[["Attempted to re apply group eventhandlers to: ",_group," when event map is: ",_eventMap]] call KISKA_fnc_log;
	_eventMap
};

private _unitJoinedGroup_eventId = _group addEventHandler ["UnitJoined", {
	params ["_group", "_newUnit"];
}];

private _unitLeftGroup_eventId = _group addEventHandler ["UnitLeft", {
	params ["_group", "_oldUnit"];
}];

private _groupIdChanged_eventId = _group addEventHandler ["GroupIdChanged", {
	params ["_group", "_newGroupId"];
	if !(isNull _group) then {
		private _selectedGroup = localNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];
		if (_group isEqualTo _selectedGroup) then {
			[false,false,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
		};

		[] call KISKA_fnc_GCH_updateSideGroupList;
	};
	
}];

private _groupLeaderChanged_eventId = _group addEventHandler ["LeaderChanged", {
	params ["_group", "_newLeader"];
}];

private _groupEmpty_eventId = _group addEventHandler ["Empty", {
	params ["_group"];
}];


_eventMap = createHashMapFromArray [
	["unitjoined",_unitJoinedGroup_eventId],
	["unitleft",_unitLeftGroup_eventId],
	["idchanged",_groupIdChanged_eventId],
	["leaderchanged",_groupLeaderChanged_eventId],
	["emptygroup",_groupEmpty_eventId]
];
_group setVariable ["KISKA_GCH_groupEventIdMap",_eventMap];


_eventMap