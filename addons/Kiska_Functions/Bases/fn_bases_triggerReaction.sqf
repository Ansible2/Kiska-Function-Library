/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig

Description:
	Spawns a configed KISKA base.

Parameters:
    0: _group <GROUP> -
    1: _combatBehaviour <STRING> -
    1: _eventConfig <CONFIG> -

Returns:
    NOTHING

Examples:
    (begin example)
		[

        ] call KISKA_fnc_bases_triggerReaction;
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

if (_combatBehaviour != "combat") exitWith {};

if (!canSuspend) exitWith {
    _this spawn KISKA_fnc_bases_triggerReaction;
    nil
};


private _priority = _group getVariable ["KISKA_bases_reinforcePriority",-1];

private _groupsToRespond = [];
_reinforceGroupIds apply {
    private _groups = KISKA_bases_idToReinforceGroups get _x;
    _groupsToRespond append _groups;
};


private _reinforceGroupIds = _group getVariable ["KISKA_bases_canCallReinforceIds",[]];
private _leaderOfCallingGroup = leader _group;
private _moveToPosition = getPosATL _leaderOfCallingGroup;

_groupsToRespond apply {
    private _currentMissionPriority = _x getVariable ["KISKA_bases_responseMissionPriority",-1];
    if (_currentMissionPriority > _priority) then {
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
};


nil
