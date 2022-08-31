/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getTimelineMap

Description:
	Returns the global timeline map of IDs and the individual info for a timeline.
	OR
	The Individual map defined for a specific timeline of the given ID. This is
	 the hashmap available in each timeline's event's code.

Parameters:
	0: _timelineId <NUMBER> - The id of the timeline to get or less than 0
		for the global timeline map

Returns:
	<HASHMAP> - A hashmap containing the timelines corresponding to their IDs
		OR the hashmap for an ID

Examples:
    (begin example)
		private _timelineMapOfAllTimelines = call KISKA_fnc_getTimelineMap;
    (end)

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

private _overallTimelineMap = localNamespace getVariable "KISKA_timelineInfoMap";
if (isNil "_timelineMap") then {
	_overallTimelineMap = createHashMap;
	localNamespace setVariable ["KISKA_timelineInfoMap",_timelineMap];
};

if (_timelineId < 0) exitWith {
	_overallTimelineMap
};


// TODO: should this return nil or empty array or empty hashmap if the map is undefined

private _timelineMap = _overallTimelineMap getOrDefault [_timelineId,[]];
if (_timelineMap isNotEqualTo []) then {
	
};