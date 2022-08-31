/* ----------------------------------------------------------------------------
Function: KISKA_fnc_isTimelineRunning

Description:
	Checks if a timeline has either fully been complete (_checkForFullCompletion = true) 
	 or is simply qued for end at the start of its next event (_checkForFullCompletion = false).

Parameters:
	0: _timelineId <NUMBER> - The id of the timeline to check
	1: _checkForFullCompletion <BOOL> - Check if the timeline's onComplete function has 
		completed and the timeline is fully done.

Returns:
	<BOOL> - The state of the timeline

Examples:
    (begin example)
		private _isRunning = [123,false] call KISKA_fnc_isTimelineRunning;
    (end)

    (begin example)
		private _timelineIsNotComplete = [123,true] call KISKA_fnc_isTimelineRunning;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_isTimelineRunning";

params [
	["_timelineId",-1,[123]],
	["_checkForFullCompletion",true,[true]]
];

if (_timelineId < 0) exitWith {
	[[_timelineId," is invalid _timelineId"],true] call KISKA_fnc_log;
	false
};

if (_checkForFullCompletion) exitWith {
	private _timelineMap = call KISKA_fnc_getTimelineMap;
	_timelineId in _timelineMap
};


localNamespace getVariable ["KISKA_timelineIsRunning_" + (str _timelineId),false]
