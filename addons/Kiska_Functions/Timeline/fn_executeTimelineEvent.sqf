scriptName "KISKA_fnc_executeTimelineEvent";

params [
	"_timeline",
	"_timelineId",
	"_previousReturn"
];

private _timelineIsStopped = [_timelineId,false] call KISKA_fnc_isTimelineStopped;
if (_timelineIsStopped) exitWith {
	// execute call back function for when timeline is stopped here only
	private _timelineMap = call KISKA_fnc_getTimelineMap;
	private _timelineValues = _timelineMap getOrDefault [_timelineId,[]];
	_timelineValues params [
		["_timeline",[],[[]]],
		["_onTimelineStopped",{},[[],{},""]]
	];

	if (_onTimelineStopped isNotEqualTo {}) then {
		[[_timeline],_onTimelineStopped] call KISKA_fnc_callBack;
	};

	_timelineMap deleteAt _timelineId;


	nil
};


private _event = _timeline deleteAt 0;
_event params [
	["_code",{},[[],{},""]],
	["_waitFor",0,[123,{},"",[]]],
	["_interval",0,[123]]
];

private _eventReturn = [_this,_code] call KISKA_fnc_callBack;
if (_timeline isEqualTo []) exitWith {
	[_timelineId] call KISKA_fnc_stopTimeline;
	[_timeline,_timelineId] call KISKA_fnc_executeTimelineEvent;
};



private _nextEventParams = [_timeline,_timelineId,_eventReturn];
if (_waitFor isEqualType 123) exitWith {
	[
		KISKA_fnc_executeTimelineEvent,
		_nextEventParams,
		_waitFor
	] call CBA_fnc_waitAndExecute;

	nil
};


[
	KISKA_fnc_executeTimelineEvent,
	_waitFor,
	_interavl,
	_nextEventParams
] call KISKA_fnc_waitUntil;


nil
