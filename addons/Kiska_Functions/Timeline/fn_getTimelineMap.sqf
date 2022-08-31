/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getTimelineMap

Description:
	The Individual map defined for a specific timeline of the given ID. This is
	 the hashmap available in each timeline's event's code.

Parameters:
	0: _timelineId <NUMBER> - The id of the timeline to get or less than 0
		for the global timeline map

Returns:
	<HASHMAP> - A hashmap containing information for the timeline events

Examples:
    (begin example)
		private _timelineMapForIdZero = [0] call KISKA_fnc_getTimelineMap;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getTimelineMap";

params [
	["_timelineId",-1,[123]]
];

private _overallTimelineMap = call KISKA_fnc_getOverallTimelineMap;
private _timelineInfo = _overallTimelineMap getOrDefault [_timelineId,[]];

if (_timelineInfo isEqualTo []) then {
	[["_timlineId: ",_timlineId," does not currently have a map"],true] call KISKA_fnc_log;
};
_timelineInfo params [
	"",
	["_timelineMap",createHashMap]
];


_timelineMap
