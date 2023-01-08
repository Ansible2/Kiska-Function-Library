/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_addGroupEventhandlers

Description:
    Adds group eventhandlers that help the GCH GUI function.

Parameters:
    0: _group <GROUP> - The Group to add the eventhandlers to

Returns:
    <HASHMAP> - A map with all event ids contained within it

Examples:
    (begin example)
        [group player] call KISKA_fnc_GCH_addGroupEventhandlers
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_addGroupEventhandlers";

if !(hasInterface) exitWith {[]};

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
    params ["_joinedGroup","_unitThatJoined"];
    
    private _selectedGroup = [] call KISKA_fnc_GCH_getSelectedGroup;
    if (_joinedGroup isEqualTo _selectedGroup) then {
        [true] call KISKA_fnc_GCH_updateCurrentGroupSection;
    };

    if (_unitThatJoined isEqualTo player) then {
        private _joinedGroupIsExcluded = [_joinedGroup] call KISKA_fnc_GCH_isGroupExcluded;
        if (!_joinedGroupIsExcluded) exitWith {};

        private _joinedGroupAlreadyHasPlayer = [group player] call KISKA_fnc_GCH_doesGroupHaveAnotherPlayer;
        if (_joinedGroupAlreadyHasPlayer) exitWith {};

        [_joinedGroup,false,true] call KISKA_fnc_GCH_setGroupExcluded;
    };
}];


private _unitLeftGroup_eventId = _group addEventHandler ["UnitLeft", {
    params ["_group", "_unitThatLeft"];

    if !(isNull _group) then {
        private _selectedGroup = [] call KISKA_fnc_GCH_getSelectedGroup;
        if (_group isEqualTo _selectedGroup) then {
            [true] call KISKA_fnc_GCH_updateCurrentGroupSection;
        };
    };
}];

private _groupIdChanged_eventId = _group addEventHandler ["GroupIdChanged", {
    params ["_group", "_newGroupId"];
    
    if !(isNull _group) then {
        private _selectedGroup = [] call KISKA_fnc_GCH_getSelectedGroup;
        if (_group isEqualTo _selectedGroup) then {
            [false,false,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
        };

        [false] call KISKA_fnc_GCH_updateSideGroupsList;
    };
}];

private _groupLeaderChanged_eventId = _group addEventHandler ["LeaderChanged", {
    params ["_group", "_newLeader"];

    if !(isNull _group) then {
        private _selectedGroup = [] call KISKA_fnc_GCH_getSelectedGroup;
        if (_group isEqualTo _selectedGroup) then {
            [false,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
        };
    };
}];

private _groupEmpty_eventId = _group addEventHandler ["Empty", {
    // params ["_group"];
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
