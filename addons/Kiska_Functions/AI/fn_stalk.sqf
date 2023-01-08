/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stalk

Description:
    Rewrite of BIS_fnc_stalk for optimizations and features.
    One provided group will continually be provided waypoints to another group's
     positions providing a "stalking" affect.

Parameters:
    0: _stalkerGroup <GROUP or OBJECT> - The group to do the stalking
    1: _stalked <GROUP or OBJECT> - The group or unit to be stalked, if group is used, 
        the leader will be stalked until every unit in the group is dead
    2: _refreshInterval <NUMBER> - How often the _stalkerGroup will have their waypoint
        updated with the position of the _stalkedGroup, and how often to check the _conditionToEndStalking
    3: _postStalking <STRING, ARRAY, or CODE> - Code that after stalking is complete
        will be executed. (See KISKA_fnc_callBack _callBackFunction parameter)
    4: _conditionToEndStalking <STRING, ARRAY, or CODE> - Code that (if returns true)
        can end the stalking. (See KISKA_fnc_callBack _callBackFunction parameter).
        The stalking will automatically end if all units in one or both groups end
        up dead.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            someGroup,
            group player,
            15,
            {hint str _this},
            {false}
        ] spawn KISKA_fnc_stalk
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stalk";


if !(canSuspend) exitWith {
    ["Must be run in scheduled environment. Exiting to scheduled...",true] call KISKA_fnc_log;
    _this spawn KISKA_fnc_stalk;
};


params [
    ["_stalkerGroup",grpNull,[objNull,grpNull]],
    ["_stalked",grpNull,[objNull,grpNull]],
    ["_refreshInterval",25,[123]],
    ["_postStalking",{},[[],{},""]],
    ["_conditionToEndStalking",{false},[[],{},""]]
];


/* ----------------------------------------------------------------------------
    Parameter verification
---------------------------------------------------------------------------- */
if (isNull _stalkerGroup) exitWith {
    ["_stalkerGroup is null! Exiting...",true] call KISKA_fnc_log;
    nil
};

private _stalkingGroup = false;
if (_stalked isEqualType grpNull) then {
    _stalked = leader _stalked;
    _stalkingGroup = true;
};
if (isNull _stalked) exitWith {
    [[_stalkerGroup," was asked to stalk a null entity! Exiting..."],true] call KISKA_fnc_log;
    nil
};


if (_refreshInterval < 5) then {
    ["_refreshInterval was less than 5, adjusting to 5",false] call KISKA_fnc_log;
    _refreshInterval = 5;
};

if (_stalkerGroup isEqualType objNull) then {
    _stalkerGroup = group _stalkerGroup;
};

private _entityCurrentlyStalking = _stalkerGroup getVariable ["KISKA_stalkingThis",objNull];
if !(isNull _entityCurrentlyStalking) exitWith {
    [
        [
            _stalkerGroup,
            " is already stalking the entity ",
            _entityCurrentlyStalking,
            " and cannot stalk multiple ones"
        ]
    ] call KISKA_fnc_log;

    nil
};



/* ----------------------------------------------------------------------------
    Main loop
---------------------------------------------------------------------------- */
_stalkerGroup setVariable ["KISKA_stalkingThis",_stalked];

private _stalkedGroup = group _stalked;
private _stalkedIsAlive = alive _stalked;
while {
    ([_stalkerGroup] call KISKA_fnc_isGroupAlive) AND 
    {
        if (_stalkingGroup) exitWith {
            [_stalkedGroup] call KISKA_fnc_isGroupAlive
        };

        _stalkedIsAlive
    }
} do {
    [_stalkerGroup] call KISKA_fnc_clearWaypoints;

    // waypoints don't work great for buildings, move command in close will have them
    // got up stairs and get on top of enemies
    private _stalkerGroupLeader = leader _stalkerGroup;
    private _distance2DBetweenGroups = _stalkerGroupLeader distance2D _stalked;
    if (_distance2DBetweenGroups > 50) then {
        [_stalkerGroup, _stalked, 25, "MOVE", "AWARE", "YELLOW", "FULL"] call CBA_fnc_addWaypoint;
    } else {
        // if not slept before and remoteExecCalled (not just remoteExec'd) unit will just stand still
        sleep 0.5;
        [_stalkerGroupLeader, (getPosATL _stalked)] remoteExecCall ["move", _stalkerGroupLeader];
    };

    private _conditionMet = [
        [_stalkerGroup,_stalked],
        _conditionToEndStalking
    ] call KISKA_fnc_callBack;
    if (_conditionMet) then {break};


    sleep _refreshInterval;

    _stalkedIsAlive = alive _stalked;
    if (_stalkingGroup AND (!_stalkedIsAlive)) then {
        _stalked = leader _stalkedGroup;
        _stalkerGroup setVariable ["KISKA_stalkingThis",_stalked];
    };
};

/* ----------------------------------------------------------------------------
    Post
---------------------------------------------------------------------------- */
if !(isNull _stalkerGroup) then {
    _stalkerGroup setVariable ["KISKA_stalkingThis",nil];
    (units _stalkerGroup) apply {
        [_x,objNull] remoteExec ["commandTarget",_x];
    };
    [_stalkerGroup] call KISKA_fnc_clearWaypoints;
};


[
    [_stalkerGroup,_stalked,_stalkedGroup],
    _postStalking
] call KISKA_fnc_callBack;


nil
