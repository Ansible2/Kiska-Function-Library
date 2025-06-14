/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_create

Description:
    Sets up an event that will fire when a percentage of objects are killed.
    Uses `"KILLED"` or `"MPKILLED"` eventhandlers.

    This should be called where the arguments are local if `_useMPKilled` is `false`
    or on the server if `_useMPKilled` is `true`.

Parameters:
    0: _objects <OBJECT[]> - An array of objects to add some form of killed event handlers to.
    1: _onThresholdMet <CODE, ARRAY, or STRING> - Code that executes once the 
        given threshold have been killed (executed after the `onKilled` of whatever 
        the last killed object was). (See `KISKA_fnc_callBack`)
                
        Params:
        - 0. <ARRAY> - The default arguments passed to either the MPKILLED or KILLED
            event handler.
        - 1. <STRING> - The ID of the multi kill event.

    2: _threshold <NUMBER> - A number between `0` and `1` that denotes the percentage 
        of objects that must've been killed to trigger the `_onThresholdMet`.
        (e.g. `1` means 100% of them need to be killed, `0.5` means 50%, etc.)
    3: _onKilled <CODE, ARRAY, or STRING> - Code that executes each time a unit has been
        killed (after the `_onThresholdMet` if threshold has been met). (See `KISKA_fnc_callBack`)
                
        Params:
        - 0. <ARRAY> - the killed evenhandler params
        - 1. <HASHMAP> - the hashmap described below in "Returns"

    4: _useMPKilled <BOOL> - Whether or not to use `"MPKILLED"` events instead of `"KILLED"`.
        IF TRUE, MUST BE RUN ON THE SERVER

Returns:
    <STRING> - An ID to identify the multi kill event.

Examples:
    (begin example)
        private _id = [
            [someObject, anotherObject],
            {
                params ["_killedEventParams","_eventId"];
                _killedEventParams params ["_killedObject"];
                hint str _this;
            }
        ] call KISKA_fnc_multiKillEvent_create;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_create";

params [
    ["_objects",[],[[]]],
    ["_onThresholdMet",{},[[],{},""]],
    ["_threshold",1,[123]],
    ["_onKilled",{},[{},[],""]],
    ["_useMPKilled",false,[true]]
];


if (_useMPKilled AND (!isServer)) exitWith {
    ["If using MPKILLED eventhandlers, this must be executed on the server!",true] call KISKA_fnc_log;
    ""
};


private _eventId = ["KISKA_multiKillEvent"] call KISKA_fnc_generateUniqueId;
private _eventMap = createHashMap;
_eventMap set ["id", _eventId];
_eventMap set ["killedCount", 0];
_eventMap set ["thresholdMet", false];

private _onEventTriggered = {
    params ["_killedEventArgs","_eventMap","_eventId"];
    private _onKilled = _eventMap getOrDefault ["onKilled",{}];
    [[_killedEventArgs,_eventId], _onKilled] call KISKA_fnc_callBack;

    if (_eventMap getOrDefaultCall ["thresholdMet",{false}]) exitWith {};

    private _total = _eventMap getOrDefaultCall ["total",{0}];
    private _killedCount = _eventMap getOrDefaultCall ["killedCount",{0}];
    _killedCount = _killedCount + 1;
    _eventMap set ["killedCount", _killedCount];

    private _threshold = _eventMap getOrDefaultCall ["threshold",{1}];
    private _metThreshold = (_killedCount / _total) >= _threshold;
    if !(_metThreshold) exitWith {};

    _eventMap set ["thresholdMet", true];
    private _onThresholdMet = _eventMap getOrDefault ["onThresholdMet",{}];
    [[_killedEventArgs,_eventId], _onThresholdMet] call KISKA_fnc_callBack;
};
_eventMap set ["onEventTriggered", _onEventTriggered];

private _eventHandlerCode = [
    "private _eventId = ",[_eventId] call KISKA_fnc_str,";",
    "private _eventMap = [_eventId] call KISKA_fnc_multiKillEvent_getEventMap;",
    "private _onEventTriggered = _eventMap getOrDefault ['onEventTriggered',{}];",
    "[_this,_eventMap,_eventId] call _onEventTriggered;"
] joinString " ";
private _type = "";
if (_useMPKilled) then {
    _type = "MPKILLED";
    _eventHandlerCode = "if (isServer) then { " + _eventHandlerCode + " };";
} else {
    _type = "KILLED";
};
_eventMap set ["eventHandlerCode", _eventHandlerCode];
_eventMap set ["type", _type];


private _containerMap = call KISKA_fnc_multiKillEvent_getContainerMap;
_containerMap set [_eventId,_eventMap];

[_eventId,_objects] call KISKA_fnc_multiKillEvent_addObjects;
[_eventId,_threshold] call KISKA_fnc_multiKillEvent_threshold;
[_eventId,_onThresholdMet] call KISKA_fnc_multiKillEvent_onThresholdMet;
[_eventId,_onKilled] call KISKA_fnc_multiKillEvent_onKilled;


_eventId
