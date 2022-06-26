/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setupKillTask

Description:


Parameters:
	0: _objects <ARRAY> - An array of objects to add MPKILLED event handlers to
	1: _taskToComplete <STRING or CONFIG> - A Kiska configured task to complete after
        all the objects are dead (with KISKA_fnc_endTask)

Returns:
	<HASHMAP> - objects and the MPKILLED event ids. Use with KISKA_fnc_hashmap_get

Examples:
    (begin example)
		[[thing1,thing2],"SomeKiskaTask"] call KISKA_fnc_setupKillTask;
    (end)
    (begin example)
		[[thing1,thing2],missionConfigFile >> "KISKA_cfgTasks" >> "SomeKiskaTask"] call KISKA_fnc_setupKillTask;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_setupKillTask";

private _hashmap = createHashMap;

if (!isServer) exitWith {
    ["Must be executed on the server!",true] call KISKA_fnc_log;
    _hashmap
};

params [
    ["_objects",[],[[]]],
    ["_taskToComplete","",["",configNull]]
];


/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if (_taskToComplete isEqualTo "") exitWith {
    ["_taskToComplete is empty string!",true] call KISKA_fnc_log;
    _hashmap
};

if (_taskToComplete isEqualType configNull AND {isNull _taskToComplete}) exitWith {
    ["_taskToComplete is null config",true] call KISKA_fnc_log;
    _hashmap
};

/* ----------------------------------------------------------------------------
    Setup event code
---------------------------------------------------------------------------- */
private _aliveObjects = [];
_objects apply {
    if (alive _x) then {
        _aliveObjects pushBackUnique _x;
    };
};

if (_aliveObjects isEqualTo []) exitWith {
    ["There are no (alive) objects to setup for",false] call KISKA_fnc_log;
    _hashmap
};

private _eventId = localNamespace getVariable ["KISKA_killTask_eventIdCount",0];
private _eventIdStr = str _eventId;
localNamespace setVariable ["KISKA_killTask_eventIdCount",_eventId + 1];

private _totalCountVar = "KISKA_killTask_totalCount_" + _eventIdStr;
localNamespace setVariable [_totalCountVar, count _aliveObjects];

private _killedCountVar = "KISKA_killTask_deadCount_" + _eventIdStr;
localNamespace setVariable [_killedCountVar, 0];

private _taskToCompleteVar = "KISKA_killTask_task_" + _eventIdStr;
localNamespace setVariable [_taskToCompleteVar,_taskToComplete];

/* ----------------------------------------------------------------------------
    Create event code
---------------------------------------------------------------------------- */
// giving it and extra set of quotes with KISKA_fnc_str so that it is a string when compiled
private _codeString = [
    "if (isServer) then { ",
        "private _totalStartingCount = localNamespace getVariable [", [_totalCountVar] call KISKA_fnc_str, ", 0]; ",
        "private _totalKilledCount = localNamespace getVariable [", [_killedCountVar] call KISKA_fnc_str, ", 0]; ",
        "_totalKilledCount = _totalKilledCount + 1; ",
        "if (_totalStartingCount isEqualTo _totalKilledCount) then { ",
            "[localNamespace getVariable [", [_taskToCompleteVar] call KISKA_fnc_str,",'']] call KISKA_fnc_endTask; ",
        "} else { ",
            "localNamespace setVariable [", [_killedCountVar] call KISKA_fnc_str, ",_totalKilledCount]; ",
        "}; ",
    "};"
] joinString "";


/* ----------------------------------------------------------------------------
    Add events
---------------------------------------------------------------------------- */
private _eventCode = compile _codeString;

_aliveObjects apply {
    private _eventId = _x addMPEventHandler ["MPKILLED",_eventCode];

    [
        _hashmap,
        _x,
        _eventId
    ] call KISKA_fnc_hashmap_set;
};


_hashmap
