/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_removeObjects

Description:
    Removes objects from the list that must be killed for a multi kill event 
     to complete.

Parameters:
    0: _id <STRING> - The multi kill event ID.
    1: _objects <OBJECT | OBJECT[]> - The objects to remove from the multi kill event.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_multiKillEvent_uid_0_0",
            MyObject
        ] call KISKA_fnc_multiKillEvent_removeObjects;
    (end)
    
    (begin example)
        [
            "KISKA_multiKillEvent_uid_0_0",
            [MyObject_1,MyObject_2]
        ] call KISKA_fnc_multiKillEvent_removeObjects;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_removeObjects";

params [
    ["_id","",[""]],
    ["_objects",objNull,[[],objNull]]
];

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

private _previousTotal = _eventMap getOrDefaultCall ["total",{0}];
private _objectHashSet = _eventMap get "objectHashSet";
private _useMpKilled = (_eventMap get "type") == "MPKILLED";
private _eventVar = _id + "_killedEventId";
private _numberRemoved = 0;
_objects apply {
    private "_killedEventId";
    if (
        !(_x isEqualType objNull) OR 
        { !(alive _x) } OR
        // not part of multi kill event
        { (isNil {_killedEventId = _x getVariable _eventVar; _killedEventId}) }
    ) then { continue };

    if (_useMPKilled) then {
        _x removeMPEventHandler ["MPKILLED", _killedEventId];
    } else {
        _x removeEventHandler ["KILLED", _killedEventId];
    };

    _x setVariable [_eventVar,nil];
    [_objectHashSet, _x] call KISKA_fnc_hashmap_deleteAt;
    _numberRemoved = _numberRemoved + 1;
};
_eventMap set ["total",_previousTotal - _numberRemoved];


nil
