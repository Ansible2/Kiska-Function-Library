/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_addObjects

Description:
    Adds objects to the list that must be killed for a multi kill event to complete.

Parameters:
    0: _id <STRING> - The multi kill event ID.
    1: _objects <OBJECT | OBJECT[]> - The objects to add to the multi kill event.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_multiKillEvent_uid_0_0",
            MyObject
        ] call KISKA_fnc_multiKillEvent_addObjects;
    (end)
    
    (begin example)
        [
            "KISKA_multiKillEvent_uid_0_0",
            [MyObject_1,MyObject_2]
        ] call KISKA_fnc_multiKillEvent_addObjects;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_addObjects";

params [
    ["_id","",[""]],
    ["_objects",objNull,[[],objNull]]
];

if (_objects isEqualType objNull) then { _objects = [_objects]; };
if (_objects isEqualTo []) exitWith {
    ["Empty _objects passed!",true] call KISKA_fnc_log;
    ""
};

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {
    [["Event ",_id," does not exist"],true] call KISKA_fnc_log;
    nil
};

if (_eventMap getOrDefaultCall ["thresholdMet",{true}]) exitWith {
    [["Event ",_id," was already completed"],false] call KISKA_fnc_log;
    nil
};

private _aliveObjects = [];
_objects apply {
    if ((_x isEqualType objNull) AND {alive _x}) then {
        _aliveObjects pushBackUnique _x;
    };
};

if (_aliveObjects isEqualTo []) exitWith {
    [["No alive objects to add to event ",_id],false] call KISKA_fnc_log;
    nil
};


private _eventType = _eventMap get "type";
private _eventHandlerCode = _eventMap get "eventHandlerCode";
private _previousTotal = _eventMap getOrDefaultCall ["total",{0}];
private _useMpKilled = _eventType == "MPKILLED";
private _eventVar = _id + "_killedEventId";
private _numberAdded = 0;
_aliveObjects apply {
    private _objectIsAlreadyInEvent = !(isNil {_x getVariable _eventVar});
    if (_objectIsAlreadyInEvent) then { continue };

    private "_killedEventId";
    if (_useMPKilled) then {
        _killedEventId = _x addMPEventHandler ["MPKILLED", _eventHandlerCode];
    } else {
        _killedEventId = _x addEventHandler ["KILLED", _eventHandlerCode];
    };

    _x setVariable [_eventVar,_killedEventId];
    _numberAdded = _numberAdded + 1;
};
_eventMap set ["total",_previousTotal + _numberAdded];


nil
