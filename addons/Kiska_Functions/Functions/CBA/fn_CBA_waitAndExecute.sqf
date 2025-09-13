/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_waitAndExecute

Description:
    Copied version of the CBA system that enables `CBA_fnc_waitAndExecute`.

Parameters:
    0: _function <CODE> - The code to execute after the wait time
    1: _args <ANY> - Any arguments to pass to the `_function`
    2: _delay <NUMBER> - How long to wait until executed the `_function` in seconds

Returns:
    NOTHING

Example:
    (begin example)
        [
            {
                player sideChat format ["5s later! _this: %1", _this];
            },
            ["some","params",1,2,3], 
            5
        ] call KISKA_fnc_CBA_waitAndExecute;
    (end)

Author(s):
    esteldunedain and PabstMirror, donated from ACE3,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_waitAndExecute";

params [
    ["_function", {}, [{}]], 
    ["_args", []], 
    ["_delay", 0, [0]]
];

KISKA_CBA_waitAndExecArray pushBack [KISKA_CBA_missionTime + _delay, _function, _args];
KISKA_CBA_waitAndExecArrayIsSorted = false;
