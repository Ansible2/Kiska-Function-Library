/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addWaypoint

Description:
    Adds a waypoint to a group.

Parameters:
    0: _group <GROUP or OBJECT> - The group or unit to give waypoints to.
    1: _center <MARKER, OBJECT, LOCATION, GROUP, TASK, WAYPOINT[], or Position[]> - 
        The position to place the waypoint's center.
    2: _type <STRING> Default: `"MOVE"` - The type of waypoint to create.
        See `setWaypointType` for options.
    
    3: _optionalArgsMap <HASHMAP> - A hashmap of various parameters for the waypoint.
        
        - `randomRadius`: <NUMBER> Default: `0` - Random waypoint placement 
           within the given radius from the `_center`; `-1` can be used for exact 
           waypoint placement but `_center` should be of type PositionASL[].
        
        - `behaviour`: <STRING> Default: `"UNCHANGED"` - See `setWaypointBehaviour` for options.

        - `combatMode`: <STRING> Default: `"NO CHANGE"` - See `setWaypointCombatMode` for options.

        - `speed`: <STRING> Default: `"UNCHANGED"` - See `setWaypointSpeed` for options.

        - `formation`: <STRING> Default: `"NO CHANGE"` - See `setWaypointFormation` for options.

        - `timeout`: <NUMBER[]> Default: `[0,0,0]` - See `setWaypointTimeout` for options.
        
        - `compRadius`: <NUMBER> Default: `0` - See `setWaypointCompletionRadius` for options.

        - `onComplete`: <CODE, STRING, or ARRAY> Default: `{}` - Code to execute upon compleition
            of the waypoint. See `KISKA_fnc_setWaypointExecStatement`.

Returns:
    <WAYPOINT[]> - The `[Group, Waypoint Index]` that was created.

Examples:
    (begin example)
        private _waypoint = [player,[0,0,0]] call KISKA_fnc_addWaypoint;
    (end)

    (begin example)
        private _waypoint = [
            player,
            [0,0,0],
            "DESTROY",
            createHashMapFromArray [
                ["onComplete",{ hint "waypoint complete!" }]
            ]
        ] call KISKA_fnc_addWaypoint;
    (end)

Author:
    Rommel,
    Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addWaypoint";

private _defaultMap = createHashMap;
params [
    ["_group",grpNull,[grpNull,objNull]],
    ["_center",[],[objNull, grpNull, "", locationNull, taskNull, [], 0]],
    ["_type","MOVE",[""]],
    ["_optionalArgsMap",_defaultMap,[_defaultMap]]
];

_group = _group call CBA_fnc_getGroup;
if (isNull _group) exitWith {
    ["null group passed",true] call KISKA_fnc_log;
    []
};

_position = _position call KISKA_fnc_CBA_getPos;
if (isNull _position) exitWith {
    ["null group position",true] call KISKA_fnc_log;
    []
};

private _optionalParamDetails = [
    ["randomRadius",{0},[123]],
    ["compRadius",{0},[123]],
    ["behaviour",{"UNCHANGED"},[""]],
    ["combatMode",{"NO CHANGE"},[""]],
    ["formation",{"NO CHANGE"},[""]],
    ["speed",{"UNCHANGED"},[""]],
    ["timeout",{[0,0,0]},[[]],3],
    ["onComplete",{{}},["",{},[]]]
];
private _optionalParams = [_optionalArgsMap,_optionalParamDetails] call KISKA_fnc_hashMapParams;
(_optionalParams select 0) params (_optionalParams select 1);


private _waypoint = _group addWaypoint [_position, _randomRadius];
_waypoint setWaypointType _type;
_waypoint setWaypointBehaviour _behaviour;
_waypoint setWaypointCombatMode _combatMode;
_waypoint setWaypointSpeed _speed;
_waypoint setWaypointFormation _formation;
_waypoint setWaypointTimeout _timeout;
_waypoint setWaypointCompletionRadius _compRadius;

if (_onComplete isNotEqualTo {}) then {
    [_waypoint,_onComplete] call KISKA_fnc_setWaypointExecStatement;
};

_waypoint
