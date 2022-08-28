scriptName "KISKA_fnc_executeTimelineEvent";

params [
	"_timeline",
	"_timelineId",
	"_previousReturn"
];

private _timelineIsStopped = [_timelineId] call KISKA_fnc_isTimelineStopped;
if (_timelineIsStopped) exitWith {};

private _event = _timeline deleteAt 0;
private _code = _event select 0;

private _eventReturn = [_this,_code] call KISKA_fnc_callBack;
if (_timeline isEqualTo []) exitWith {};


private _nextEventParams = [_timeline,_timelineId,_eventReturn];

private _waitFor = _event select 1;
if (_waitFor isEqualType 123) exitWith {
	[
		KISKA_fnc_executeTimelineEvent,
		_nextEventParams,
		_waitFor
	] call CBA_fnc_waitAndExecute;
};

private _interavl = _event select 2;
[
	KISKA_fnc_executeTimelineEvent,
	_waitFor,
	_interavl,
	_nextEventParams
] call KISKA_fnc_waitUntil;