/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_triggerReaction

Description:
	Acts as the default event for the reactive bases when a group calls for reinforcements.

Parameters:
    0: _group <GROUP> - The group the event is triggering for
    1: _detectedTarget <OBJECT> - The enemy unit that was detected

Returns:
    NOTHING

Examples:
    (begin example)
		[
            someGroup,
            anEnemyUnit
        ] call KISKA_fnc_bases_triggerReaction
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_triggerReaction";

params [
    ["_group",grpNull,[grpNull]],
    ["_detectedTarget",objNull,[objNull]]
];

if ((isNull _group) OR (isNull _detectedTarget)) exitWith {};


private _reinforceGroupIds = _group getVariable ["KISKA_bases_canCallReinforceIds",[]];
private _groupsToRespond = [];
_reinforceGroupIds apply {
    private _groups = KISKA_bases_reinforceGroupsMap get _x;
    _groupsToRespond append _groups;
};


private _priority = _group getVariable ["KISKA_bases_reinforcePriority",-1];
private _onEnemyDetected = _group getVariable ["KISKA_bases_reinforceOnEnemyDetected",{}];
private _preventDefault = false;

if (_onEnemyDetected isNotEqualTo {}) then {
    _preventDefault = [
        _group,
        _detectedTarget,
        _groupsToRespond,
        _priority
    ] call _onEnemyDetected;
};


if (_preventDefault) exitWith {};


/* ----------------------------------------------------------------------------
    Default response behviour
---------------------------------------------------------------------------- */
[
    _group,
    _detectedTarget,
    _groupsToRespond,
    _priority
] spawn {
    scriptName "KISKA_fnc_bases_triggerReaction";
    params ["_group","_detectedTarget","_groupsToRespond","_priority"];

    sleep 3;

    private _groupIsAlive = [_group] call KISKA_fnc_isGroupAlive;
    if !(_groupIsAlive) exitWith {};

    private _simDistance = dynamicSimulationDistance "Group";
    private "_leaderOfCallingGroup";
    private _exit = false;
    // TODO: this loop is not needed, units not simmed will not have their EnemyDetected eventhandler fire
    waitUntil {
        sleep 2;
        // in case leader changes
        _leaderOfCallingGroup = leader _group;
        _exit = !(alive _leaderOfCallingGroup) OR !(alive _detectedTarget);
        if (_exit) exitWith {true};
        
        _leaderOfCallingGroup distance _detectedTarget <= _simDistance
    };

    // TODO more robust handling if one of these units is dead
    if (_exit) exitWith {
        [
            [
                "exited due to either _leaderOfCallingGroup: ",
                _leaderOfCallingGroup,
                " or _detectedTarget: ",
                _detectedTarget,
                " being dead: ",
                alive _leaderOfCallingGroup,
                " | ",
                alive _detectedTarget
            ]
        ] call KISKA_fnc_log;
        nil
    };

    private _groupRespondingToId = _group getVariable ["KISKA_bases_respondingToId",""];
    private _groupIsAlsoResponding = _groupRespondingToId isNotEqualTo "";
    private _groupReinforceId = _group getVariable ["KISKA_bases_reinforceId",""];
    private _groupToStalk = group _detectedTarget;

    _groupsToRespond apply {
        private _currentMissionPriority = _x getVariable ["KISKA_bases_responseMissionPriority",-1];
        private _currentlyStalkedGroup = _x getVariable ["KISKA_bases_stalkingGroup",grpNull];

        if (
            (_currentMissionPriority > _priority) OR 
            (!(isNull _currentlyStalkedGroup) AND (_groupToStalk isEqualTo _currentlyStalkedGroup))
        ) then {
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

        _x setVariable ["KISKA_bases_stalkingGroup",_groupToStalk];

        private _currentBehaviour = combatBehaviour _x;
        private _distanceBetweenGroups = _leaderOfRespondingGroup distance _leaderOfCallingGroup;
        if (
            (_distanceBetweenGroups > 20) AND
            (_currentBehaviour != "combat")
        ) then {
            [_x,"aware"] remoteExec ["setBehaviourStrong",_leaderOfRespondingGroup];
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
        
        [_x, _groupToStalk, 15, {
            params ["_stalkerGroup"];
            _stalkerGroup setVariable ["KISKA_bases_responseMissionPriority", nil];
            _stalkerGroup setVariable ["KISKA_bases_respondingToId", nil];
            _stalkerGroup setVariable ["KISKA_bases_stalkingGroup", nil];
        }] spawn KISKA_fnc_stalk;

        _x setVariable ["KISKA_bases_responseMissionPriority",_priority];
        _x setVariable ["KISKA_bases_respondingToId", _groupReinforceId];
    };
};




nil
