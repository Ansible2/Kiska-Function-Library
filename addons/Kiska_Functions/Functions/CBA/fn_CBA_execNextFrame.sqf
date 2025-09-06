/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_execNextFrame

Description:
    Copied function `CBA_fnc_execNextFrame` from CBA3.

    Executes a code once in and unscheduled environment on the next frame.

Parameters:
    0: _code <CODE> - Code to execute.
    1: _args <ANY> Default: `[]` - Parameters to call the code with.

Returns:
    NOTHING

Example:
    (begin example)
        0 spawn { 
            {systemChat str canSuspend} call KISKA_fnc_CBA_directCall; 
        };
    (end)

Author(s):
    esteldunedain and PabstMirror, donated from ACE3,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_execNextFrame";

params [
    ["_function", {}, [{}]], 
    ["_args", []]
];

if (diag_frameNo isNotEqualTo KISKA_CBA_nextFrameNo) then {
    KISKA_CBA_nextFrameBufferA pushBack [_args, _function];
} else {
    KISKA_CBA_nextFrameBufferB pushBack [_args, _function];
};