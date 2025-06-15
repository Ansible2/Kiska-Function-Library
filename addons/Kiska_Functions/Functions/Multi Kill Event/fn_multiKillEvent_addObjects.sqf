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
if (_objects isEqualTo []) exitWith {};

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {
    [["Event ",_id," does not exist"],true] call KISKA_fnc_log;
    nil
};

if (_eventMap getOrDefaultCall ["thresholdMet",{true}]) exitWith {
    [["Event ",_id," was already completed"],false] call KISKA_fnc_log;
    nil
};

private _eventHandlerCode = _eventMap get "eventHandlerCode";
private _previousTotal = _eventMap getOrDefaultCall ["total",{0}];
private _objectHashSet = _eventMap get "objectHashSet";
private _eventType = _eventMap get "type";
private _useMpKilled = _eventType == "MPKILLED";
private _eventVar = _id + "_killedEventId";
private _numberAdded = 0;
_objects apply {
    if (
        !(_x isEqualType objNull) OR 
        { !(alive _x) } OR
        // already part of multi kill event
        { !(isNil {_x getVariable _eventVar}) }
    ) then { continue };

    private "_killedEventId";
    if (_useMPKilled) then {
        _killedEventId = _x addMPEventHandler ["MPKILLED", _eventHandlerCode];
    } else {
        _killedEventId = _x addEventHandler ["KILLED", _eventHandlerCode];
    };

    _x setVariable [_eventVar,_killedEventId];
    [_objectHashSet, _x, _x] call KISKA_fnc_hashmap_set;
    _numberAdded = _numberAdded + 1;
};
_eventMap set ["total",_previousTotal + _numberAdded];


nil
// To solve issue, simply have a hashmap that effectively is a set
// So all the keys are the objects and their values are also the objects
// that way you can just use the values command.