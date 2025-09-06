/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_directCall

Description:
    Copied function `CBA_fnc_directCall` from CBA3.

    Executes a piece of code in unscheduled environment.

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
    commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_directCall";

params [
    ["_KISKA_CBA_code", {}, [{}]], 
    ["_KISKA_CBA_args", []]
];


private "_KISKA_CBA_return";

isNil {
    // Wrap the _KISKA_CBA_code in an extra call block to prevent problems with exitWith and apply
    _KISKA_CBA_return = ([_x] apply {_KISKA_CBA_args call _KISKA_CBA_code}) select 0;
};

if !(isNil "_KISKA_CBA_return") then {_KISKA_CBA_return};
