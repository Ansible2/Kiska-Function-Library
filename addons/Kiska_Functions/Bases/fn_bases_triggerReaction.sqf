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

// don't try to fight air vehicles
private _targetVehicleALT = (getPosATL _detectedTarget) select 2;
if (_targetVehicleALT >= 5) exitWith {
    [
        [
            _group,
            " detected a target that could not be reached: ",
            _detectedTarget,
            " which is of type: ",
            typeOf _detectedTarget 
        ],
        false
    ] call KISKA_fnc_log;
    nil
};


/* ----------------------------------------------------------------------------
    Default response behviour
---------------------------------------------------------------------------- */
private _fnc_findReplacementTarget = {
    params ["_group"];

    private _simDistance = dynamicSimulationDistance "Group";
    private _targets = [];
    private "_leaderOfCallingGroup";
    waitUntil {
        sleep 2;
        // in case leader changes
        _leaderOfCallingGroup = leader _group;
        if !(alive _leaderOfCallingGroup) exitWith {true};
        _targets = _leaderOfCallingGroup targets [true, _simDistance];
        if (_targets isEqualTo []) then {continueWith false};

        private _foundEnemyIndex = _targets findIf { !(captive _x) };
        _foundEnemyIndex isNotEqualTo -1;
    };

    // in case _closestEnemy dies while processing
    private _closestEnemy = objNull;
    private _distanceOfClosest = -1;
    _targets apply {
        if (captive _x) then {continue};

        private _distance = _x distance _leaderOfCallingGroup;
        if (!(alive _closestEnemy) OR (_distance < _distanceOfClosest)) then {
            _distanceOfClosest = _distance;
            _closestEnemy = _x;
        };
    };


    _closestEnemy
};



[
    _group,
    _detectedTarget,
    _groupsToRespond,
    _priority,
    _fnc_findReplacementTarget
] spawn {
    scriptName "KISKA_fnc_bases_triggerReaction";

    params ["_group","_detectedTarget","_groupsToRespond","_priority","_fnc_findReplacementTarget"];

    sleep 3;

    private _groupIsAlive = [_group] call KISKA_fnc_isGroupAlive;
    if !(_groupIsAlive) exitWith {};

    if (
        !(alive _detectedTarget) AND
        {
            _detectedTarget = [_group] call _fnc_findReplacementTarget;
            isNull _detectedTarget
        }
    ) exitWith {
        ["Original detected target is not alive and could not find replacement"] call KISKA_fnc_log;
        nil
    };

    private _groupRespondingToId = _group getVariable ["KISKA_bases_respondingToId",""];
    private _groupIsAlsoResponding = _groupRespondingToId isNotEqualTo "";
    private _groupReinforceId = _group getVariable ["KISKA_bases_reinforceId",""];
    private _leaderOfCallingGroup = leader _group;

    _groupsToRespond apply {
        private _currentMissionPriority = _x getVariable ["KISKA_bases_responseMissionPriority",-1];
        private _currentlyStalked = _x getVariable ["KISKA_bases_stalkingThis",objNull];

        if (
            (_currentMissionPriority > _priority) OR 
            (!(isNull _currentlyStalked) AND (_detectedTarget isEqualTo _currentlyStalked))
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

        _x setVariable ["KISKA_bases_stalkingThis",_detectedTarget];

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
        
        [_x, _detectedTarget, 15, {
            params ["_stalkerGroup","_stalkedUnit","_stalkedGroup"];
            
            private _groupIsAlive = [_stalkerGroup] call KISKA_fnc_isGroupAlive;
            if (!_groupIsAlive) exitWith {};

            private _canStalkGroup = [_stalkedGroup] call KISKA_fnc_isGroupAlive;
            if (!_canStalkGroup) exitWith {
                _stalkerGroup setVariable ["KISKA_bases_responseMissionPriority", nil];
                _stalkerGroup setVariable ["KISKA_bases_respondingToId", nil];
                _stalkerGroup setVariable ["KISKA_bases_stalkingThis", nil];
            };
 
            [
                _stalkerGroup,
                _stalkedGroup,
                20,
                {
                    params ["_stalkerGroup"];
                    
                    _stalkerGroup setVariable ["KISKA_bases_responseMissionPriority", nil];
                    _stalkerGroup setVariable ["KISKA_bases_respondingToId", nil];
                    _stalkerGroup setVariable ["KISKA_bases_stalkingThis", nil];
                }
            ] spawn KISKA_fnc_stalk;
            
        }] spawn KISKA_fnc_stalk;

        _x setVariable ["KISKA_bases_responseMissionPriority",_priority];
        _x setVariable ["KISKA_bases_respondingToId", _groupReinforceId];
    };
};




nil
