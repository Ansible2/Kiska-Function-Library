/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stopTimeline

Description:
	Ques a timeline to end on the next execution of an event in it or at the very
	 end of the timeline. This will immediately set KISKA_fnc_isTimelineStopped
	 (where _isFullyComplete-is-false) to be true.

Parameters:
	0: _timelineId <NUMBER> - The id of the timeline to stop
	1: _onTimelineStopped <CODE, STRING, or ARRAY> - (see KISKA_fnc_callBack),
		code that will be executed once a timeline is stopped. Params:
			0: <ARRAY> - The timeline array in the state when the stoppage actually happens.

Returns:
	NOTHING

Examples:
    (begin example)
		[123] call KISKA_fnc_stopTimeline;
    (end)

    (begin example)
		[123,{hint str ["timeline stopped!",_this]}] call KISKA_fnc_stopTimeline;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stopTimeline";

params [
	["_timelineId",-1,[123]],
	["_onTimelineStopped",{},[[],{},""]]
];

if (_timelineId < 0) exitWith {
	[[_timelineId," is invalid _timelineId"],true] call KISKA_fnc_log;
	nil
};

if (_onTimelineStopped isNotEqualTo {}) then {
	private _timelineMap = call KISKA_fnc_getTimelineMap;
	private _timelineValues = _timelineMap getOrDefault [_timelineId,[]];
	private _timelineHasNotEnded = _timelineValues isNotEqualTo [];
	if (_timelineHasNotEnded) then {
		_timelineValues set [1,_onTimelineStopped];
	};
};


localNamespace setVariable ["KISKA_timelineIsRunning_" + (str _timelineId),nil];


nil
