/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getOverallTimelineMap

Description:
    Returns the global timeline map of IDs and the individual info for a timeline.

Parameters:
    NONE

Returns:
    <HASHMAP> - The overall timeline map to get info on certain timelines

Examples:
    (begin example)
        private _overallTimelineMap = call KISKA_fnc_getOverallTimelineMap;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getOverallTimelineMap";

private _overallTimelineMap = localNamespace getVariable "KISKA_overallTimelineMap";
if (isNil "_overallTimelineMap") then {
    _overallTimelineMap = createHashMap;
    localNamespace setVariable ["KISKA_overallTimelineMap",_overallTimelineMap];
};


_overallTimelineMap
