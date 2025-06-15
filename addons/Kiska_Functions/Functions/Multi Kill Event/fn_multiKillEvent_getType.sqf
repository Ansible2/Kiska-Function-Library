/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_getType

Description:
    Returns the event type for the given multi kill event. Whether or not the event
     is a MPKILLED or KILLED event.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <STRING | NIL> - The type of kill event (`"KILLED"` or `"MPKILLED"`)

Examples:
    (begin example)
        private _type = [
            "KISKA_multiKillEvent_uid_0_0"
        ] call KISKA_fnc_multiKillEvent_getType;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_getType";

params [
    ["_id","",[""]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {};

_eventMap get "type"
