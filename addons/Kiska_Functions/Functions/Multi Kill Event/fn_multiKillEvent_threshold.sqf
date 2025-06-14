/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_threshold

Description:
    Gets or sets the threshold of the multi kill event which is the percentage of
     killed objects that must be met in order for the event to be considered complete.
     (e.g. 1 means 100% of them need to be killed, 0.5 means 50%, etc.)

Parameters:
    0: _id <STRING> - The multi kill event ID.
    1: _threshold <NUMBER | NIL> - Default: `nil` - What to set the threshold to.
        The number will be clamped to be between `0` and `1`. If `nil`, the function
        will act as a getter for the current value.

Returns:
    <NUMBER | NIL> - The current threshold of the event or `nil` if the event does not exist.

Examples:
    (begin example)
        private _newThreshold = [
            "KISKA_multiKillEvent_uid_0_0",
            1
        ] call KISKA_fnc_multiKillEvent_threshold;
    (end)

    (begin example)
        private _currentThreshold = [
            "KISKA_multiKillEvent_uid_0_0",
        ] call KISKA_fnc_multiKillEvent_threshold;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_threshold";

params [
    ["_id","",[""]],
    ["_threshold",nil,[123]]
];

private _eventMap = _id call KISKA_fnc_multiKillEvent_getEventMap;
if (isNil "_eventMap") exitWith {};
if (isNil "_threshold") exitWith { _eventMap get "threshold" };

if (_threshold > 1) then {
    [["Provided invalid threshold (must be between 0 and 1): ",_threshold," and clamped to 1"],false] call KISKA_fnc_log;
    _threshold = 1;
};
if (_threshold < 0) then {
    [["Provided invalid threshold (must be between 0 and 1): ",_threshold," and clamped to 0"],false] call KISKA_fnc_log;
    _threshold = 0;
};
_eventMap set ["threshold",_threshold];


_threshold
