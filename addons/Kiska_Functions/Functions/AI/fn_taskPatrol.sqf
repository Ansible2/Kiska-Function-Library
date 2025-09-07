/* ----------------------------------------------------------------------------
Function: KISKA_fnc_taskPatrol

Description:
    A modified version of `CBA_fnc_taskPatrol`.

    A function for a group to randomly patrol a parsed radius and location.

    Should be executed where the `_group` is local.

Parameters:
    0: _group <GROUP or OBJECT> - The group or unit to give waypoints to.
    1: _center <MARKER, OBJECT, LOCATION, GROUP, TASK, WAYPOINT[], or Position[]> - 
        The position to place the waypoint's center.
    2: _radius <NUMBER> Default: `100` - The radius of the area to create 
        random patrol points.
    3: _numberOfWaypoints <NUMBER> Default: `3` - The number of waypoints to 
        generate for the group. Minimum of `2`.
    4: _waypointArgsMap <HASHMAP> - A hashmap of various parameters for the waypoints.
        
        - `type`: <STRING> Default: `"MOVE"` - See `setWaypointType` for options.

        - `behaviour`: <STRING> Default: `"UNCHANGED"` - See `setWaypointBehaviour` for options.

        - `combatMode`: <STRING> Default: `"NO CHANGE"` - See `setWaypointCombatMode` for options.

        - `speed`: <STRING> Default: `"UNCHANGED"` - See `setWaypointSpeed` for options.

        - `formation`: <STRING> Default: `"NO CHANGE"` - See `setWaypointFormation` for options.

        - `timeout`: <NUMBER[]> Default: `[0,0,0]` - See `setWaypointTimeout` for options.
        
        - `compRadius`: <NUMBER> Default: `0` - See `setWaypointCompletionRadius` for options.

        - `onComplete`: <CODE, STRING, or ARRAY> Default: `{}` - Code to execute upon compleition
            of the waypoint. See `KISKA_fnc_setWaypointExecStatement`.

Returns:
    <WAYPOINT[][]> - The list of waypoints `[Group, Waypoint Index][]` that were created.

Examples:
    (begin example)
        [MyGroup,[0,0,0]] call KISKA_fnc_taskPatrol;
    (end)

    (begin example)
        private _waypoints = [
            player,
            [0,0,0],
            200,
            5,
            createHashMapFromArray [
                ["onComplete",{ hint "waypoint complete!" }],
                ["type","DESTROY"]
            ]
        ] call KISKA_fnc_taskPatrol;
    (end)

Author:
    Rommel,
    Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_taskPatrol";

private _defaultMap = createHashMap;
params [
    ["_group",grpNull,[grpNull,objNull]],
    ["_center",[],[objNull, grpNull, "", locationNull, taskNull, [], 0]],
    ["_radius",100,[123]],
    ["_numberOfWaypoints",3,[123]],
    ["_waypointArgsMap",_defaultMap,[_defaultMap]]
];

_group = _group call CBA_fnc_getGroup;
if (isNull _group) exitWith {
    ["null group",true] call KISKA_fnc_log;
    []
};
if !(local _group) exitWith {
    ["group was not local to the machine!",true] call KISKA_fnc_log;
    []
};

if (
    (_center isEqualTypeAny [grpNull,objNull]) AND 
    {isNull _center}
) exitWith {
    ["null center passed",true] call KISKA_fnc_log;
    []
};

[_group] call KISKA_fnc_clearWaypoints;
(units _group) apply {
    _x enableAI "PATH";
};

_numberOfWaypoints = _numberOfWaypoints MIN 2;
// Using angles create better patrol patterns
// Also fixes weird editor bug where all WP are on same position
private _step = 360 / _numberOfWaypoints;
private _offset = random _step;
private _waypoints = [];
private _waypointType = _waypointArgsMap getOrDefaultCall ["type",{"MOVE"}];
_waypointArgsMap set ["randomRadius",-1];
for "_i" from 1 to _numberOfWaypoints do {
    // Gaussian distribution avoids all waypoints ending up in the center
    private _rad = _radius * random [0.1, 0.75, 1];

    // Alternate sides of circle & modulate offset
    private _theta = (_i % 2) * 180 + sin (deg (_step * _i)) * _offset + _step * _i;

    private _waypoint = [
        _group,
        _position getPos [_rad, _theta],
        _waypointType,
        _waypointArgsMap
    ] call KISKA_fnc_addWaypoint;
    _waypoints pushBack _waypoint;
};

_waypointArgsMap set ["randomRadius",_radius];
private _cycleWaypoint = [
    _group,
    _position,
    "CYCLE",
    _waypointArgsMap
] call KISKA_fnc_addWaypoint;
_waypoints pushBack _cycleWaypoint;


_waypoints
