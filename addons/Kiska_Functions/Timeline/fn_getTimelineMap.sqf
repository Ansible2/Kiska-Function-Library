/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getTimelineMap

Description:
	Returns the global timeline map of IDs and the individual info for a timeline.

Parameters:
	NONE

Returns:
	<HASHMAP> - A hashmap containing the timelines corresponding to their IDs

Examples:
    (begin example)
		private _timelineMap = call KISKA_fnc_getTimelineMap;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getTimelineMap";

private _timelineMap = localNamespace getVariable "KISKA_timelineInfoMap";
if (isNil "_timelineMap") then {
	_timelineMap = createHashMap;
	localNamespace setVariable ["KISKA_timelineInfoMap",_timelineMap];
};


_timelineMap