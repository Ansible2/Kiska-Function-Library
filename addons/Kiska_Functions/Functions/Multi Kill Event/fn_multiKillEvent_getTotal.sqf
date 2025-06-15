/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_getTotal

Description:
    Returns the total number of objects that have been assigned to the multi kill 
     event at the current moment.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <NUMBER | NIL> - The total number of objects assigned to the multi kill event.

Examples:
    (begin example)
        private _totalNumberOfObjects = [
            "KISKA_multiKillEvent_uid_0_0"
        ] call KISKA_fnc_multiKillEvent_getTotal;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_getTotal";

params [
    ["_id","",[""]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {};

_eventMap get "total"
