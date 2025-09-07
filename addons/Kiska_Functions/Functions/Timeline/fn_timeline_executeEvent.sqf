/* ----------------------------------------------------------------------------
Function: KISKA_fnc_timeline_executeEvent

Description:
    Executes a recursive chain timeline events. This should not be executed on its
     own but begins from KISKA_fnc_timeline_start.

Parameters:
    0: _timelineEvents <ARRAY> - An array of timeline events that will happen. 
        See KISKA_fnc_timeline_start for formats
    1: _timelineId <STRING> - The id of the timeline to stop
    2: _timelineMap <HASHMAP> - The Individual map defined for a specific timeline of the given ID
    3: _previousReturn <ANY> - The returned value from the previous events function

Returns:
    NOTHING

Examples:
    (begin example)
        [_timelineEvents,"KISKA_timeline_1"] call KISKA_fnc_timeline_executeEvent
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_timeline_executeEvent";

params [
    ["_timelineEvents",[],[[]]],
    ["_timelineId","",[""]],
    "_timelineMap",
    "_previousReturn"
];


private _timelineIsRunning = [_timelineId,false] call KISKA_fnc_timeline_isRunning;
if !(_timelineIsRunning) exitWith {
    // execute call back function for when timeline is stopped here only
    private _overallTimelineMap = call KISKA_fnc_timeline_getMainMap;
    private _timelineValues = _overallTimelineMap getOrDefault [_timelineId,[]];
    _timelineValues params [
        ["_timelineValueEvents",[],[[]]],
        "_timelineMap",
        ["_onTimelineStopped",{},[[],{},""]]
    ];

    if (_onTimelineStopped isNotEqualTo {}) then {
        [[_timelineValueEvents,_timelineMap],_onTimelineStopped] call KISKA_fnc_callBack;
    };

    _overAllTimelineMap deleteAt _timelineId;


    nil
};


private _event = _timelineEvents deleteAt 0;
_event params [
    ["_code",{},[[],{},""]],
    ["_waitFor",0,[123,{},"",[]]],
    ["_interval",0,[123]]
];

private _eventReturn = [_this,_code] call KISKA_fnc_callBack;
// this is checked right after event call in case timeline was cleared during event
if (_timelineEvents isEqualTo []) then {
    [_timelineId] call KISKA_fnc_timeline_stop;
};


private _nextEventParams = [_timelineEvents,_timelineId,_timelineMap];
if !(isNil "_eventReturn") then {
    _nextEventParams pushBack _eventReturn
};


if (_waitFor isEqualType 123) exitWith {
    [
        KISKA_fnc_timeline_executeEvent,
        _nextEventParams,
        _waitFor
    ] call KISKA_fnc_CBA_waitAndExecute;

    nil
};


[
    _waitFor,
    KISKA_fnc_timeline_executeEvent,
    _interval,
    _nextEventParams
] call KISKA_fnc_waitUntil;


nil
