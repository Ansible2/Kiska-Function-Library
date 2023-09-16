/* ----------------------------------------------------------------------------
Function: KISKA_fnc_timeline_setIsRunning

Description:
    Sets whether a given timeline is considered to be running.

Parameters:
    0: _timelineId <STRING> - The timeline's id
    1: _isRunning <BOOL> - `true` to set as running, `false` to set as NOT

Returns:
    NOTHING

Examples:
    (begin example)
        // internal function that should not be directly called
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_timeline_setIsRunning";

params [
    ["_timelineId","",[""]],
    ["_isRunning",true,[true]]
];


private _isRunningMap = call KISKA_fnc_timeline_getIsRunningMap;
_isRunningMap set [_timelineId,_isRunning];


nil
