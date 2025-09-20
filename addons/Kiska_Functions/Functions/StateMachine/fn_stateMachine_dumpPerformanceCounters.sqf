/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_dumpPerformanceCounters

Description:
    Copied function `CBA_statemachine_fnc_dumpPerformanceCounters` from CBA.

    Dumps the performance counters for each state machine to the `.rpt` log. 
     Requires that `KISKA_fnc_stateMachine_onEachFrame` and this function have 
     `STATEMACHINE_PERFORMANCE_COUNTERS` `#define`d within their exectuion.
    
    Note that `diag_tickTime` has very limited precision; results may become 
     more accurate with longer test runtime.

Parameters:
    NONE

Returns:
    NOTHING

Example:
    (begin example)
        [] call KISKA_fnc_stateMachine_dumpPerformanceCounters;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_dumpPerformanceCounters";

#ifndef STATEMACHINE_PERFORMANCE_COUNTERS
    if (true) exitWith {
        ["Must have STATEMACHINE_PERFORMANCE_COUNTERS #define 'd",true] call KISKA_fnc_log;
        nil
    };
#endif

diag_log text format ["KISKA State Machine Performance Results:"];
diag_log text format ["--------------------- START %1 ----------------------",systemTime];

KISKA_stateMachines apply {
    private _guid = _x;
    private _stateMachineMap = _y;
    
    private _performanceCounters = _stateMachineMap get "performanceCounters";
    if (_performanceCounters isEqualTo []) then {
        diag_log text format ["State Machine: %1 - NO DATA", _guid];
        continue;
    };

    private _numberOfDataPoints = count _performanceCounters;
    private _sumOfDataPoints = 0;
    _performanceCounters apply { _sumOfDataPoints = _sumOfDataPoints + _x };
    private _averageExecutionTimeEachFrame = 1000 * _sumOfDataPoints / _numberOfDataPoints;

    diag_log text format [
        "State Machine %1: Average: %2 ms [%3s / %4]", 
        _stateMachineID, 
        _averageExecutionTimeEachFrame toFixed 3, 
        _sumOfDataPoints toFixed 3, 
        _numberOfDataPoints
    ];
};


nil
