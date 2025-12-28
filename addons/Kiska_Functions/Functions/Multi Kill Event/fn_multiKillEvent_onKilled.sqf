/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_onKilled

Description:
    Gets or sets the code that is executed when a given object is killed that 
     is part of the given multi kill event.

Parameters:
    0: _id <STRING> - The multi kill event ID.
    1: _onKilled <CODE, ARRAY, or STRING> - Code that executes each time an object 
        has been killed (executed before the `onThresholdMet` if threshold has been met). 
        (See `KISKA_fnc_callBack`)
                
        Params:
        - 0. <ARRAY> - The default arguments passed to either the MPKILLED or KILLED
            event handler.
        - 1. <STRING> - The ID of the multi kill event.

Returns:
    <CODE, ARRAY, STRING, or NIL> - The current value of the onKilled property.

Examples:
    (begin example)
        private _newOnKilled = [
            "KISKA_multiKillEvent_uid_0_0",
            {hint "hello"}
        ] call KISKA_fnc_multiKillEvent_onKilled;
    (end)

    (begin example)
        private _currentOnKilled = [
            "KISKA_multiKillEvent_uid_0_0",
        ] call KISKA_fnc_multiKillEvent_onKilled;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_onKilled";

params [
    ["_id","",[""]],
    ["_onKilled",nil,[{},[],""]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {
    [["_id ",_id," does not exist"]] call KISKA_fnc_log;
    nil
};
if (isNil "_onKilled") exitWith { _eventMap get "onKilled" };

_eventMap set ["onKilled",_onKilled];
_onKilled
