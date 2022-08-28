scriptName "KISKA_fnc_executeTimelineEvent";

params [
	"_timeline",
	"_timelineId",
	"_previousReturn"
];

private _timelineIsStopped = [_timelineId] call KISKA_fnc_isTimelineStopped;
if (_timelineIsStopped) exitWith {};

private _event = _timeline deleteAt 0;
_event params [
	["_code",{},[[],{},""]],
	["_waitFor",0,[123,{},"",[]]],
	["_interval",0,[123]]
];

private _eventReturn = [_this,_code] call KISKA_fnc_callBack;
if (_timeline isEqualTo []) exitWith {
	[_timelineId] call KISKA_fnc_stopTimeline;
};


private _nextEventParams = [_timeline,_timelineId,_eventReturn];

if (_waitFor isEqualType 123) exitWith {
	[
		KISKA_fnc_executeTimelineEvent,
		_nextEventParams,
		_waitFor
	] call CBA_fnc_waitAndExecute;
};


[
	KISKA_fnc_executeTimelineEvent,
	_waitFor,
	_interavl,
	_nextEventParams
] call KISKA_fnc_waitUntil;


nil
