params ["_timeline"];

private _timelineId = ["KISKA_timelines"] call KISKA_fnc_idCounter;
localNamespace setVariable ["KISKA_timelineIsRunning_" + (str _timelineId),true];

[
	_timeline,
	_timelineId
] call KISKA_fnc_executeTimelineEvent;


_timelineId

// example events
[
	{

	},
	{
		// condition perframe
	},
	0
]

[
	{
		
	},
	{
		// condition eval every second
	},
	1
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
		
	},
	[_timeline]
] call CBA_fnc_execNextFrame;