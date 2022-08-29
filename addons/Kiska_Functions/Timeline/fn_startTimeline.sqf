params [
	["_timeline",[],[[]]],
	["_onTimelineStopped",{},[[],{},""]]
];

// as a user
// I want to be able to provide a custom function to execute
// when manually calling KISKA_fnc_stopTimeline

// as a user
// I want my timeline to not execute the next timeline event if
// it is manually stopped and I wan to execute the _onTimelineStopped
// code I defined

// as a user
// I want to have all the above happen also when I reach the end of the
// timeline

private _timelineId = ["KISKA_timelines"] call KISKA_fnc_idCounter;
private _timelineMap = localNamespace getVariable "KISKA_timelineInfoMap";
if (isNil "_timelineMap") then {
	_timelineMap = createHashMap;
	localNamespace setVariable ["KISKA_timelineInfoMap",_timelineMap];
};

private _timelineMapId = "KISKA_timeline_" + (str _timelineId);
_timelineMap set [_timelineMapId,[_timeline,_onTimelineStopped]];

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