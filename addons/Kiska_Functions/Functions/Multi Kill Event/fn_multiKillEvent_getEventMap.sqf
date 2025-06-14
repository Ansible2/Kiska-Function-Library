/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_getEventMap

Description:
    Returns the metadata map for a multi kill event. Ideally should not be modified
    directly as it may create unintended behaviour.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <HASHMAP | NIL> - A hashmap containing info about the event:

    - `id`: <STRING> - The ID of the multi kill event.
    - `total`: <NUMBER> - The total number of objects that have this killed event.
    - `killedCount`: <NUMBER> - The total number of objects that have been killed 
        with this event.
    - `threshold`: <NUMBER> - A number that indicates the percentage of objects that
        must be killed (relative to the total) for this event to fire
        (e.g. `1` means 100% of them need to be killed, `0.5` means 50%, etc.)
    - `thresholdMet`: <BOOL> - Whether or not the threshold has been met and therefore
        onThresholdMet has fired
    - `onKilled`: <CODE, ARRAY, or STRING> - Code that executes each time an object 
        has been killed (executed before the `onThresholdMet` if threshold has been met). 
        (See `KISKA_fnc_callBack`)
                
        Params:
        - 0. <ARRAY> - The default arguments passed to either the MPKILLED or KILLED
            event handler.
        - 1. <STRING> - The ID of the multi kill event.

    - `onThresholdMet`: <CODE, ARRAY, or STRING> - Code that executes once the 
        given threshold have been killed (executed after the `onKilled` of whatever 
        the last killed object was). (See `KISKA_fnc_callBack`)
                
        Params:
        - 0. <ARRAY> - The default arguments passed to either the MPKILLED or KILLED
            event handler.
        - 1. <STRING> - The ID of the multi kill event.

    - `eventCode`: <CODE> - The code that is attached to the killed eventhandler
    - `type`: <STRING> - Type of event, (`"KILLED"` or `"MPKILLED"`)

Examples:
    (begin example)
        private _eventMap = "KISKA_multiKillEvent_uid_0_0" call KISKA_fnc_multiKillEvent_getEventMap;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_getEventMap";

params [
    ["_id","",[""]]
];


(call KISKA_fnc_multiKillEvent_getContainerMap) get _id
