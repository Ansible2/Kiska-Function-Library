/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_getKilledCount

Description:
    Returns the number of objects that have been killed throughout the course of
     the multi kill event's lifetime.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <NUMBER | NIL>

Examples:
    (begin example)
        private _numberOfKilledObjects = [
            "KISKA_multiKillEvent_uid_0_0"
        ] call KISKA_fnc_multiKillEvent_getKilledCount;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_getKilledCount";

params [
    ["_id","",[""]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {};

_eventMap get "killedCount"
