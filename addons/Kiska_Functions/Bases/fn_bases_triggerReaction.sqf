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
private _preventDefault = false;
if (_onEnteredCombat isNotEqualTo {}) then {
    _preventDefault = [
        _group,
        _groupsToRespond,
        _priority
    ] call _onEnteredCombat;
};



if (_preventDefault) exitWith {};

/* ----------------------------------------------------------------------------
    Default response behviour
---------------------------------------------------------------------------- */
[_group,_groupsToRespond,_priority] spawn {
    params ["_group","_groupsToRespond","_priority"];

    sleep 3;

    private _groupIsAlive = [_group] call KISKA_fnc_isGroupAlive;
    if !(_groupIsAlive) exitWith {};

    private _simDistance = dynamicSimulationDistance "Group";
    private _targets = [];
    private "_leaderOfCallingGroup";
    waitUntil {
        sleep 1;
        // in case leader changes
        _leaderOfCallingGroup = leader _group;
        if !(alive _leaderOfCallingGroup) exitWith {true};
        _targets = _leaderOfCallingGroup targets [true, _simDistance];
        _targets isNotEqualTo []
    };

    // in case _closestEnemy dies while processing
    private _closestEnemy = objNull;
    private _distanceOfClosest = -1;
    _targets apply {
        private _distance = _x distance _leaderOfCallingGroup;
        if (!(alive _closestEnemy) OR (_distance < _distanceOfClosest)) then {
            _distanceOfClosest = _distance;
            _closestEnemy = _x;
        };
    };

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
            (_distanceBetweenGroups > 20) AND
            (_currentBehaviour != "combat")
        ) then {
            [_x,"aware"] remoteExec ["setBehaviour",_leaderOfRespondingGroup];
            [_x,"aware"] remoteExec ["setCombatBehaviour",_leaderOfRespondingGroup];

        };

        private _groupUnits = units _x;
        // reset infantry positions
        _groupUnits apply {
            private _isAnimated = [_x] call KISKA_fnc_ambientAnim_isAnimated;
            if (_isAnimated) then {
                [_x] call KISKA_fnc_ambientAnim_stop;
            };
            
            [_x,"AUTO"] remoteExec ["setUnitPos",_x];
        };
        // in case unit was told to stop with doStop
        [_groupUnits, _leaderOfRespondingGroup] remoteExec ["doFollow", _leaderOfRespondingGroup];

        // some time is needed after reseting units with doFollow or they will lock up
        sleep 1;

        [_x, group _closestEnemy, 15, {
            params ["_stalkerGroup"];
            _stalkerGroup setVariable ["KISKA_bases_responseMissionPriority", nil];
            _stalkerGroup setVariable ["KISKA_bases_respondingToId", nil];
        }] spawn KISKA_fnc_stalk;

        _x setVariable ["KISKA_bases_responseMissionPriority",_priority];
        _x setVariable ["KISKA_bases_respondingToId", _groupReinforceId];
    };
};




nil
