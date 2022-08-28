params ["_timeline"];

// example events
[
	{

	},
	{
		// condition perframe
	}
]

[
	{
		
	},
	[{
		// condition eval every second
	},1]
]

[
	{
		params ["_thisTimeline"];
		[_thisTimeline,{
			// some callback function
		}] call KISKA_fnc_stopTimeline;
	},
	2 // execute 2 seconds after previous event
]


[
	{
		params ["_timeline","_id"];
		private _timelineIsStopped = [_id] call KISKA_fnc_isTimelineStopped;
		if (_timelineIsStopped) exitWith {};

		private _event = _timeline deleteAt 0;

		private _code = _timeline select 0;
		private _waitFor = _timeline select 1;
		private _returnFromCode = [[],_code] call KISKA_fnc_callBack;
		if (_waitFor isEqualType 123) exitWith {
			[
				KISKA_fnc_executeTimelineEvent,
				[_timeline],
				_waitFor
			] call CBA_fnc_waitAndExecute;
		};
	},
	[_timeline]
] call CBA_fnc_execNextFrame;