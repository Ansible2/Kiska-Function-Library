/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getOverallTimelineMap

Description:
    The map that links a given timeline id to its info map. This is an internal function
     that you (likely) don't need to use. See KISKA_fnc_timeline_getInfoMap to retrieve
     an info map for a given timeline.

Parameters:
    NONE

Returns:
    <HASHMAP> - The overall timeline map to get info on certain timelines

Examples:
    (begin example)
        // internal function that should not be called directly
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
