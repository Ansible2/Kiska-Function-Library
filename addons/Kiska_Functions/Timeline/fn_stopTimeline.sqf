params [
	["_timelineId",-1,[123]]
];

if (_timelineId < 0) exitWith {
	[[_timelineId," is invalid _timelineId"],true] call KISKA_fnc_log;
	nil
};


localNamespace setVariable ["KISKA_timelineIsRunning_" + (str _timelineId),nil];


nil
