/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_isThresholdMet

Description:
    Checks whether or not the threshold of the given multi kill event has been met.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <BOOL> - Whether the threshold for the kill event has been met. Also will 
        return `false` if the event does not exist.

Examples:
    (begin example)
        private _thresholdMet = [
            "KISKA_multiKillEvent_uid_0_0"
        ] call KISKA_fnc_multiKillEvent_isThresholdMet;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_isThresholdMet";

params [
    ["_id","",[""]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith { false };

_eventMap get "thresholdMet"
