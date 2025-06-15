/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_isObjectInEvent

Description:
    Checks whether or not the threshold of the given multi kill event has been met.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <BOOL> - Whether the object is part of the multi kill event. If the event of
        the given ID does not exist or the given `_object` is null `false` will
        also be returned.

Examples:
    (begin example)
        private _isInMultiKillEvent = [
            "KISKA_multiKillEvent_uid_0_0",
            MyObject
        ] call KISKA_fnc_multiKillEvent_isObjectInEvent;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_isObjectInEvent";

params [
    ["_id","",[""]],
    ["_object",objNull,[objNull]]
];

if (isNull _object) exitWith { false };

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith { false };

private _objectHashSet = _eventMap get "objectHashSet";
[_objectHashSet, _object] call KISKA_fnc_hashmap_in
