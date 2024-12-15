/* ----------------------------------------------------------------------------
Function: KISKA_fnc_timeline_getInfoMap

Description:
    The Individual map defined for a specific timeline of the given ID. This is
     the hashmap available in each timeline's event's code.

Parameters:
    0: _timelineId <STRING> - The id of the timeline to get

Returns:
    <HASHMAP> - A hashmap containing information for the timeline events

Examples:
    (begin example)
        private _timelineMapForId = ["KISKA_timeline_1"] call KISKA_fnc_timeline_getInfoMap;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_timeline_getInfoMap";

params [
    ["_timelineId","",[""]]
];


private _overallTimelineMap = call KISKA_fnc_timeline_getMainMap;
if !(_timelineId in _overallTimelineMap) then {
    [["_timlineId: ",_timlineId," does not exist!"],true] call KISKA_fnc_log;
    nil
};


private _timelineInfo = _overallTimelineMap get _timelineId;
_timelineInfo select 1
