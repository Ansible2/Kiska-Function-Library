/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_triggerReaction

Description:
	Acts as the default event for the reactive bases when a group calls for reinforcements.

Parameters:
    0: _group <GROUP> - The group the event is triggering for
    1: _combatBehaviour <STRING> - The group's current behviour
    2: _eventConfig <CONFIG> - The eventhandler config (OPTIONAL)

Returns:
    NOTHING

Examples:
    (begin example)
		[
            someGroup,
            "combat"
        ] call KISKA_fnc_bases_triggerReaction
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_triggerReaction";

params [
    ["_group",grpNull,[grpNull]],
    ["_combatBehaviour","",[""]],
    ["_eventConfig",configNull,[configNull]]
];

if (isNull _group) exitWith {};

if (_combatBehaviour != "combat") exitWith {};


private _reinforceGroupIds = _group getVariable ["KISKA_bases_canCallReinforceIds",[]];

private _groupsToRespond = [];
_reinforceGroupIds apply {
    private _groups = KISKA_bases_reinforceGroupsMap get _x;
    _groupsToRespond append _groups;
};


private _priority = _group getVariable ["KISKA_bases_reinforcePriority",-1];
private _onEnteredCombat = _group getVariable ["KISKA_bases_reinforceOnEnteredCombat",{}];
if (_onEnteredCombat isNotEqualTo {}) then {
    private _preventDefault = [
        _group,
        _groupsToRespond,
        _priority
    ] call _onEnteredCombat;
};



private _leaderOfCallingGroup = leader _group;
private _moveToPosition = getPosATL _leaderOfCallingGroup;
private _groupRespondingToId = _group getVariable ["KISKA_bases_respondingToId",""];
private _groupIsAlsoResponding = _groupRespondingToId isNotEqualTo "";
private _groupReinforceId = _group getVariable ["KISKA_bases_reinforceId",""];

_groupsToRespond apply {
    private _currentMissionPriority = _x getVariable ["KISKA_bases_responseMissionPriority",-1];
    if (_currentMissionPriority > _priority) then {
        continue;
    };

    // check that the group being called doesn't already have
    // the group calling responding to them
    // e.g. group1 calls for group2, group2 then calls for group1
    // group2 shouldn't acknowledge this because group1 already called
    private _reinforceId = _x getVariable ["KISKA_bases_reinforceId",""];
    private _willBeCircularResponse = _reinforceId isEqualTo _groupRespondingToId;
    if (_groupIsAlsoResponding AND _willBeCircularResponse) then {
        continue;
    };

    private _leaderOfRespondingGroup = leader _x;
    if ((isNull _x) OR (isNull _leaderOfRespondingGroup)) then {
        continue;
    };

    private _currentBehaviour = combatBehaviour _x;
    private _distanceBetweenGroups = _leaderOfRespondingGroup distance _leaderOfCallingGroup;
    if (
        (_distanceBetweenGroups <= 20) AND
        (_currentBehaviour != "combat")
    ) then {
        [_x,"combat"] remoteExec ["setCombatBehaviour",_leaderOfRespondingGroup];

    } else {
        [_x,"aware"] remoteExec ["setCombatBehaviour",_leaderOfRespondingGroup];

    };

    private _groupUnits = units _x;
    // reset infantry positions
    _groupUnits apply {
        _x setVariable ["KISKA_bases_stopAmbientAnim",true];
        [_x,"AUTO"] remoteExec ["setUnitPos",_x];
    };
    // in case unit was told to stop with doStop
    [_groupUnits, _leaderOfRespondingGroup] remoteExec ["doFollow", _leaderOfRespondingGroup];
    [_leaderOfRespondingGroup, _moveToPosition] remoteExec ["move", _leaderOfRespondingGroup];
    _x setVariable ["KISKA_bases_respondingToId", _groupReinforceId];
};




nil
