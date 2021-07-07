/* ----------------------------------------------------------------------------
Function: KISKA_fnc_monitorFPS

Description:
	Keeps track of the local machine's FPS for a given duration and prints
     data to log file.

Parameters:
	0: _duration <NUMBER> - How long the test will run
	1: _frequency <NUMBER> - Time between checks
	2: _print <BOOL> - Shows a hint on screen

Returns:
	NOTHING

Examples:
    (begin example)
        [60] call KISKA_fnc_monitorFPS;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_monitorFPS";

params [
    ["_duration",60,[123]],
    ["_frequency",0.1,[123]],
    ["_print",false,[true]]
];

private _fpsArray = [];
private _fps = 0;

sleep 2; // in case somebody is leaving a menu from execution this gives a small buffer so the the min fps is actually representative

private _timeToEnd = time + _duration;
while {time < _timeToEnd} do {
    _fps = diag_fps;
    if (_print) then {
        hint str _fps;
    };

    _fpsArray pushBack _fps;
    sleep _frequency;
};

private _high = selectMax _fpsArray;
private _low = selectMin _fpsArray;

private _average = -1;
_fpsArray apply {
    _average =  _average + _x;
};
_average = _average / (count _fpsArray);

private _printOut = "FPS Test has ended: AVERAGE: " + str _average + " MAX: " + str _high + " MIN: " + str _low;
hint _printOut;
diag_log _printOut;
