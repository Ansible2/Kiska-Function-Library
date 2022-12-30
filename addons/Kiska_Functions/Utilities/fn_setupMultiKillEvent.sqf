/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setupMultiKillEvent

Description:
    Sets up an event that will fire when a percentage of objects are killed.
    Uses KILLED or MPKILLED eventhandlers.

    This should be called where the arguements are local if _useMPKilled is false
    or on the server if _useMPKilled is true;

Parameters:
	0: _objects <ARRAY> - An array of objects to add some form of killed event handlers to
	1: _onThresholdMet <CODE, ARRAY, or STRING> - Code that executes once it has been determined
        that the threshold has been met or exceeded. (See KISKA_fnc_callBack). If attempting
        to add more units to an existing event, use the event id here (see returned hashmap below for id)
        and preceed the event id with a "#" (see examples)
            Params:
                
                0. <ARRAY> - the killed evenhandler params
                1. <HASHMAP> - the hashmap described below in "Returns"

    // NOT USED if adding to existing event
    2: _threshold <NUMBER> - A number between 0 and 1 that denotes the percentage of objects that
        must've been killed to trigger the _onThresholdMet.
        (e.g. 1 means 100% of them need to be killed, 0.5 means 50%, etc.)
    3: _onKilled <CODE, ARRAY, or STRING> - Code that executes each time a unit has been
            killed (after the _onThresholdMet if threshold has been met). (See KISKA_fnc_callBack)
                Params:
                    
                    0. <ARRAY> - the killed evenhandler params
                    1. <HASHMAP> - the hashmap described below in "Returns"

    4: _useMPKilled <BOOL> - Whether or not to use "MPKILLED" events instead of "KILLED".
        IF TRUE, MUST BE RUN ON THE SERVER

Returns:
	<HASHMAP> - A hashmap containing info about the event
        "id": <STRING> - A localNamespace variable name to access this hashmap
        "total": <NUMBER> - The total number of objects that have this killed event
        "killed": <NUMBER> - The total number of objects that have been killed with this event
        "threshold": <NUMBER> - A number that indicates the percentage of objects that
            must be killed (relative to the total) for this event to fire
            (e.g. 1 means 100% of them need to be killed, 0.5 means 50%, etc.)
        "thresholdMet": <BOOL> - Whether or not the threshold has been met and therefore
            onThresholdMet has fired
        "onKilled": <CODE, ARRAY, or STRING> - Code that executes each time a unit has been
            killed (after the _onThresholdMet if threshold has been met). (See KISKA_fnc_callBack)
                Params:
                    
                    0. <ARRAY> - the killed evenhandler params
                    1. <HASHMAP> - the hashmap described

        "onThresholdMet": <CODE, ARRAY, or STRING> - Code that executes once it has been determined
            that the threshold has been met or exceeded. (See KISKA_fnc_callBack)
                Params:
                    
                    0. <ARRAY> - the killed evenhandler params
                    1. <HASHMAP> - the hashmap described

        "eventCode": <CODE> - The code that is attached to the killed eventhandler
        "type": <STRING> - Type of event, ("KILLED" or "MPKILLED")
        "objectToEventIdMap": <HASHMAP> -  A hashmap that uses objects as keys (should use KISKA_fnc_hashmap_get)
            to get the killed eventhandler id attached to an object.

Examples:
    (begin example)
        private _eventMap = [
            [someObject, anotherObject],
            {
                params ["_killedEventParams","_eventMap"];
                _killedEventParams params ["_killedObject"];
                hint str [_killedEventParams, _eventMap];
            }
        ] call KISKA_fnc_setupMultiKillEvent;
    (end)

    // add more objects to the existing event made above
    (begin example)
        private _eventMap = [
            [andAdditionalObject],
            ("#" + (_eventMap get "id"))
        ] call KISKA_fnc_setupMultiKillEvent;
    (end)
    
Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_setupMultiKillEvent";

params [
    ["_objects",[],[[]]],
    ["_onThresholdMet",{},[[],{},""]],
    ["_threshold",1,[123]],
    ["_onKilled",{},[{},[],""]],
    ["_useMPKilled",false,[true]]
];

/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if (_useMPKilled AND (!isServer)) exitWith {
    ["If using MPKILLED eventhandlers, this must be executed on the server!",true] call KISKA_fnc_log;
    []
};

if (_objects isEqualTo []) exitWith {
    ["Empty _objects passed!",true] call KISKA_fnc_log;
    []
};

if (_threshold > 1) then {
    [["Provided invalid threshold (must be between 0 and 1): ",_threshold," and clamped to 1"],false] call KISKA_fnc_log;
    _threshold = 1;
};
if (_threshold < 0) then {
    [["Provided invalid threshold (must be between 0 and 1): ",_threshold," and clamped to 0"],false] call KISKA_fnc_log;
    _threshold = 0;
};

private _existingEventId = "";
if (_onThresholdMet isEqualType "") then {
    private _startsWithHashTag = (_onThresholdMet select [0,1]) isEqualTo "#";
    if (_startsWithHashTag) then {
        _existingEventId = _onThresholdMet trim ["#",1];
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
    private _eventMap = localNamespace getVariable [_existingEventId,[]];
    if (_eventMap isEqualTo []) exitWith {
        [["Could not locate event map for ", _existingEventId],true] call KISKA_fnc_log;
        []
    };
    _useMPKilled = (_eventMap getOrDefault ["type","KILLED"]) == "MPKILLED";
    if (_useMPKilled AND (!isServer)) exitWith {
        ["If using MPKILLED eventhandlers, this must be executed on the server!",true] call KISKA_fnc_log;
        []
    };

    private _eventHandlerCode = _eventMap getOrDefault ["eventHandlerCode",{}];
    _aliveObjects apply {
        private _eventId = -1;
        if (_useMPKilled) then {
            _eventId = _x addMPEventHandler ["MPKILLED", _eventHandlerCode];

        } else {
            _eventId = _x addEventHandler ["KILLED", _eventHandlerCode];

        };

        [
            _objectToEventIdMap,
            _x,
            _eventId
        ] call KISKA_fnc_hashmap_set;
    };

    private _total = _eventMap getOrDefault ["total",0];
    _eventMap set ["total", _total + (count _aliveObjects)];


    _eventMap
};


/* ----------------------------------------------------------------------------
    Setup Event Map
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



/* ----------------------------------------------------------------------------
    Add eventhandlers
---------------------------------------------------------------------------- */
private _eventHandlerCode = [
    // giving it and extra set of quotes with KISKA_fnc_str so that it is a string when compiled
    "private _eventMap = localNamespace getVariable [", [_eventMapVar] call KISKA_fnc_str, ", []]; ",
    "private _eventCode = _eventMap getOrDefault ['eventCode',{}]; ",
    "[_this, [[_eventMap],_eventCode]] call KISKA_fnc_callBack;"
] joinString "";
_eventMap set ["eventHandlerCode", _eventHandlerCode];

private _type = "";
if (_useMPKilled) then {
    _type = "MPKILLED";
    _eventHandlerCode = "if (isServer) then { " + _eventHandlerCode + " };";

} else {
    _type = "KILLED";

};

private _objectToEventIdMap = createHashMap;
_aliveObjects apply {
    private _eventId = -1;
    if (_useMPKilled) then {
        _eventId = _x addMPEventHandler ["MPKILLED", _eventHandlerCode];
    } else {
        _eventId = _x addEventHandler ["KILLED", _eventHandlerCode];
    };

    [
        _objectToEventIdMap,
        _x,
        _eventId
    ] call KISKA_fnc_hashmap_set;
};


private _eventCode = {
    _thisArgs params ["_eventMap"];

    if !(_eventMap getOrDefault ["thresholdMet",false]) then {
        private _total = _eventMap getOrDefault ["total",0];
        private _killedCount = _eventMap getOrDefault ["killed",0];
        _killedCount = _killedCount + 1;
        _eventMap set ["killed", _killedCount];

        private _threshold = _eventMap getOrDefault ["threshold",1];
        private _metThreshold = (_killedCount / _total) >= _threshold;

        if (_metThreshold) then {
            _eventMap set ["thresholdMet", true];
            private _onThresholdMet = _eventMap getOrDefault ["onThresholdMet",{}];
            [[_this, _eventMap], _onThresholdMet] call KISKA_fnc_callBack;
        };
    };

    private _onKilled = _eventMap getOrDefault ["onKilled",{}];
    // _this is normal eventhandler parameters from "killed" event
    [[_this, _eventMap], _onKilled] call KISKA_fnc_callBack;
};

_eventMap set ["eventCode", _eventCode];
_eventMap set ["type", _type];
_eventMap set ["objectToEventIdMap",_objectToEventIdMap];



_eventMap
