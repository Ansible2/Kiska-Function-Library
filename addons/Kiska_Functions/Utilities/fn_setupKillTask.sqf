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

params [
    ["_objects",[],[[]]],
    ["_onThresholdMet",{},[[],{},""]],
    ["_threshold",1,[123]],
    ["_onKilled",{},[{},[],""]],
    ["_useMPKilled",true,[false]]
];

/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if (_objects isEqualTo []) exitWith {
    ["Empty _objects passed!",true] call KISKA_fnc_log;
    []
};

private _existingEventId = "";
if (_onThresholdMet isEqualType "") then {
    private _startsWithHashTag = (_onThresholdMet select [0,1]) isEqualTo "#";
    if (_startsWithHashTag) then {
        _existingEventId = _onThresholdMet trim [1,"#"];
    };
};


private _aliveObjects = [];
_objects apply {
    if (_x isEqualType objNull AND {alive _x}) then {
        _aliveObjects pushBackUnique _x;
    };
};

if (_aliveObjects isEqualTo []) exitWith {
    ["There are no alive objects to setup kill event for...",false] call KISKA_fnc_log;
    []
};


/* ----------------------------------------------------------------------------
    Handle existing event
---------------------------------------------------------------------------- */
if (_existingEventId isNotEqualTo "") exitWith {

};


/* ----------------------------------------------------------------------------
    Setup Event
---------------------------------------------------------------------------- */
private _eventId = localNamespace getVariable ["KISKA_killedManyEvent_idCount",0];
private _eventIdStr = str _eventId;
localNamespace setVariable ["KISKA_killedManyEvent_idCount",_eventId + 1];

private _eventMap = createHashMap;
private _eventMapVar = "KISKA_killedManyEvent_map_" + _eventIdStr;
localNamespace setVariable [_eventMapVar, _eventMap];
_eventMap set ["id", _eventMapVar];
_eventMap set ["total", count _aliveObjects];
_eventMap set ["killed", 0];
_eventMap set ["threshold", _threshold];
_eventMap set ["thresholdMet", false];
_eventMap set ["onKilled", _onKilled];
_eventMap set ["onThresholdMet", _onthresholdMet];


private _eventCode = [
    // giving it and extra set of quotes with KISKA_fnc_str so that it is a string when compiled
    "private _eventMap = localNamespace getVariable [", [_eventMapVar] call KISKA_fnc_str, ", []]; ",
    "if !(_eventMap getOrDefault ['thresholdMet',false]) then { ",
        "private _total = _eventMap getOrDefault ['total',0]; ",
        "private _killedCount = _eventMap getOrDefault ['killed',0]; ",
        "_killedCount = _killedCount + 1; ",
        "_eventMap set ['killed', _killedCount]; ",
        "private _threshold = _eventMap getOrDefault ['threshold',1]; ",
        "private _metThreshold = (_currentDeadCount / _totalUnitCount) >= _threshold; ",
        "if (_metThreshold) then { ",
            "_eventMap set ['thresholdMet', true]; ",
            "private _onThresholdMet = _eventMap getOrDefault ['onThresholdMet',{}]; ",
            "[_eventMap, _onThresholdMet] call KISKA_fnc_callBack; ",
        "} else { ",
            "private _onKilled = _eventMap getOrDefault ['onKilled',{}]; ",
            "[_eventMap, _onKilled] call KISKA_fnc_callBack; ",
        "}; ",
    "};"
] joinString "";


private _objectToEventIdMap = createHashMap;
private _type = "";
if (_useMPKilled) then {
    _type = "MPKILLED";
    _eventCode = "if (isServer) then { " + _eventCode + "};";
    _aliveObjects apply {
        private _eventId = _x addMPEventHandler ["MPKILLED",_eventCode];

        [
            _objectToEventIdMap,
            _x,
            _eventId
        ] call KISKA_fnc_hashmap_set;
    };

} else {
    _type = "KILLED";
    _aliveObjects apply {
        private _eventId = _x addEventHandler ["KILLED", _eventCode];

        [
            _objectToEventIdMap,
            _x,
            _eventId
        ] call KISKA_fnc_hashmap_set;
    };

};

_eventMap set ["type", _type];
_eventMap set ["objectToEventIdMap",_objectToEventIdMap]



_eventMap
