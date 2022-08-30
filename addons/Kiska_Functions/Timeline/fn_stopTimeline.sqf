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
