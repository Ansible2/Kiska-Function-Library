/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stalk

Description:
	Rewrite of BIS_fnc_stalk for optimizations and features.
    One provided group will continually be provided waypoints to another group's
     positions providing a "stalking" affect.

Parameters:
    0: _stalkerGroup <GROUP or OBJECT> - The group to do the stalking
    1: _stalkedGroup <GROUP or OBJECT> - The group to be stalked
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
    ["_stalkedGroup",grpNull,[objNull,grpNull]],
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

if (isNull _stalkedGroup) exitWith {
    ["_stalkedGroup is null! Exiting...",true] call KISKA_fnc_log;
    nil
};

if (_refreshInterval < 5) exitWith {
    ["_refreshInterval was less than 5, adjusting to 5",true] call KISKA_fnc_log;
    _refreshInterval = 5;
    nil
};

if (_stalkerGroup isEqualType objNull) then {
    _stalkerGroup = group _stalkerGroup;
};

private _groupAlreadyBeingStalked = _stalkerGroup getVariable ["KISKA_isStalking",grpNull];
if !(isNull _groupAlreadyBeingStalked) exitWith {
    [[_stalkerGroup," is already stalking the group ",_groupAlreadyBeingStalked," an cannot stalk multiple groups"]] call KISKA_fnc_log;
    nil
};

if (_stalkedGroup isEqualType objNull) then {
    _stalkedGroup = group _stalkedGroup;
};


/* ----------------------------------------------------------------------------
    Main loop
---------------------------------------------------------------------------- */
_stalkerGroup setVariable ["KISKA_stalkingGroup",_stalkedGroup];
[_stalkerGroup] call KISKA_fnc_clearWaypoints;

private _stalkedGroupIsStalkable = true;
private _stalkerGroupCanStalk = true;

while {_stalkerGroupCanStalk AND _stalkedGroupIsStalkable} do {
    [_stalkerGroup] call KISKA_fnc_clearWaypoints;

    private _stalkerGroupLeader = leader _stalkerGroup;
    private _stalkedGroupLeader = leader _stalkedGroup;
    // waypoints don't work great for buildings, move command in close will have them
    // got up stairs and get on top of enemies
    private _distance2DBetweenGroups = _stalkerGroupLeader distance2D _stalkedGroupLeader;
    if (_distance2DBetweenGroups > 50) then {
        [_stalkerGroup, _stalkedGroupLeader, 25, "MOVE", "AWARE", "YELLOW", "FULL"] call CBA_fnc_addWaypoint;
    } else {
        // if not slept before and remoteExecCalled (not just remoteExec'd) unit will just stand still
        sleep 0.5;
        [_stalkerGroupLeader, (getPosATL _stalkedGroupLeader)] remoteExecCall ["move", _stalkerGroupLeader];
    };

    private _conditionMet = [
        [_stalkerGroup,_stalkedGroup],
        _conditionToEndStalking
    ] call KISKA_fnc_callBack;
    if (_conditionMet) then {break};


    sleep _refreshInterval;


    _stalkerGroupCanStalk = [_stalkerGroup] call KISKA_fnc_isGroupAlive;
    _stalkedGroupIsStalkable = [_stalkedGroup] call KISKA_fnc_isGroupAlive;
};

/* ----------------------------------------------------------------------------
    Post
---------------------------------------------------------------------------- */
if !(isNull _stalkerGroup) then {
    _stalkerGroup setVariable ["KISKA_stalkingGroup",nil];
    (units _stalkerGroup) apply {
        [_x,objNull] remoteExec ["commandTarget",_x];
    };
    [_stalkerGroup] call KISKA_fnc_clearWaypoints;
};


[
    [_stalkerGroup,_stalkedGroup],
    _postStalking
] call KISKA_fnc_callBack;


nil
