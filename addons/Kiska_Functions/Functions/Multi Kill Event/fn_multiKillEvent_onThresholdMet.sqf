/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_onThresholdMet

Description:
    Gets or sets the code that is executed when the threshold of objects required to
     complete the multi kill event have been killed.

Parameters:
    0: _id <STRING> - The multi kill event ID.
    1: _onThresholdMet <CODE, ARRAY, or STRING> - Code that executes once the 
        given threshold have been killed (executed after the `onKilled` of whatever 
        the last killed object was). (See `KISKA_fnc_callBack`)
                
        Params:
        - 0. <ARRAY> - The default arguments passed to either the MPKILLED or KILLED
            event handler.
        - 1. <STRING> - The ID of the multi kill event.

Returns:
    <CODE, ARRAY, STRING, or NIL> - The current value of the onThresholdMet property.

Examples:
    (begin example)
        private _newOnThresholdMet = [
            "KISKA_multiKillEvent_uid_0_0",
            {hint "hello"}
        ] call KISKA_fnc_multiKillEvent_onThresholdMet;
    (end)

    (begin example)
        private _currentOnThresholdMet = [
            "KISKA_multiKillEvent_uid_0_0",
        ] call KISKA_fnc_multiKillEvent_onThresholdMet;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_onThresholdMet";

params [
    ["_id","",[""]],
    ["_onThresholdMet",nil,[{},[],""]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {};
if (isNil "_onThresholdMet") exitWith { _eventMap get "onThresholdMet" };

_eventMap set ["onThresholdMet",_onThresholdMet];
_onThresholdMet
