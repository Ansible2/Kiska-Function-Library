/* ----------------------------------------------------------------------------
Function: KISKA_fnc_executeTimelineEvent

Description:
    Executes a recursive chain timeline events. This should not be executed on its
     own but begins from KISKA_fnc_startTimeline.

Parameters:
    0: _timeline <ARRAY> - An array of timeline events that will happen. 
        See KISKA_fnc_startTimeline for formats
    1: _timelineId <NUMBER> - The id of the timeline to stop
    2: _timelineMap <HASHMAP> - The Individual map defined for a specific timeline of the given ID
    3: _previousReturn <ANY> - The returned value from the previous events function

Returns:
    NOTHING

Examples:
    (begin example)
        [_timeline,123] call KISKA_fnc_executeTimelineEvent
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_executeTimelineEvent";

params [
    ["_timeline",[],[[]]],
    ["_timelineId",-1,[123]],
    "_timelineMap",
    "_previousReturn"
];

if (_timelineId < 0) exitWith {
    [[_timelineId," is invalid _timelineId"],true] call KISKA_fnc_log;
    nil
};

private _timelineIsRunning = [_timelineId,false] call KISKA_fnc_isTimelineRunning;
if !(_timelineIsRunning) exitWith {
    // execute call back function for when timeline is stopped here only
    private _overallTimelineMap = call KISKA_fnc_getOverallTimelineMap;
    private _timelineValues = _overallTimelineMap getOrDefault [_timelineId,[]];
    _timelineValues params [
        ["_timeline",[],[[]]],
        "_timelineMap",
        ["_onTimelineStopped",{},[[],{},""]]
    ];

    if (_onTimelineStopped isNotEqualTo {}) then {
        [[_timeline,_timelineMap],_onTimelineStopped] call KISKA_fnc_callBack;
    };

    _overAllTimelineMap deleteAt _timelineId;


    nil
};


private _event = _timeline deleteAt 0;
_event params [
    ["_code",{},[[],{},""]],
    ["_waitFor",0,[123,{},"",[]]],
    ["_interval",0,[123]]
];

private _eventReturn = [_this,_code] call KISKA_fnc_callBack;
if (_timeline isEqualTo []) then {
    [_timelineId] call KISKA_fnc_stopTimeline;
};


private _nextEventParams = [_timeline,_timelineId,_timelineMap];
if !(isNil "_eventReturn") then {
    _nextEventParams pushBack _eventReturn
};


if (_waitFor isEqualType 123) exitWith {
    [
        KISKA_fnc_executeTimelineEvent,
        _nextEventParams,
        _waitFor
    ] call CBA_fnc_waitAndExecute;

    nil
};


[
    _waitFor,
    KISKA_fnc_executeTimelineEvent,
    _interval,
    _nextEventParams
] call KISKA_fnc_waitUntil;


nil
