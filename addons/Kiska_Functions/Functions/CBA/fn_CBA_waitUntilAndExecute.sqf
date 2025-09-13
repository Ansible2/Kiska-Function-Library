/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_waitUntilAndExecute

Description:
    Copied version of the CBA system that enables `CBA_fnc_waitUntilAndExecute`.

    Executes a code once in unscheduled environment after a condition is `true`.
     It's also possible to add a timeout >= 0, in which case a different code is executed.
     Then it will be waited until `_timeout` time has elapsed or _condition evaluates to `true`.

Parameters:
    0: _condition <CODE> - The function to evaluate as condition.
    1: _statement <CODE> - The function to run if the condition is true before timeout.
    2: _args <ANY> Default: `[]` - Parameters passed to the functions 
        (statement and condition) executing.
    3: _timeout <NUMBER> Default: `-1` - If >= 0, timeout for the condition in seconds.  
        If < 0, no timeout. Exactly 0 means timeout immediately on the next iteration.
    4: _timeoutCode <CODE> Default: `{}` - When provided, will be executed if 
        condition times out.

Returns:
    NOTHING

Example:
    (begin example)
        [
            { (_this select 0) == vehicle (_this select 0) }, 
            { (_this select 0) setDamage 1; }, 
            [player]
        ] call KISKA_fnc_CBA_waitUntilAndExecute;
    (end)
    (begin example)
        [
            { backpackCargo _this isEqualTo [] }, 
            { deleteVehicle _this; },
            _holder,
            5,
            { hint backpackCargo _this; }
        ] call KISKA_fnc_CBA_waitUntilAndExecute;
    (end)

Author(s):
    joko // Jonas, donated from ACE3,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_waitUntilAndExecute";

params [
    ["_condition", {}, [{}]],
    ["_statement", {}, [{}]],
    ["_args", []],
    ["_timeout", -1, [0]],
    ["_timeoutCode", {}, [{}]]
];

if (_timeout < 0) then {
    KISKA_CBA_waitUntilAndExecArray pushBack [_condition, _statement, _args];
} else {
    KISKA_CBA_waitUntilAndExecArray pushBack [
        {
            params ["_condition", "_statement", "_args", "_timeout", "_timeoutCode", "_startTime"];

            if (CBA_missionTime - _startTime > _timeout) exitWith {
                _args call _timeoutCode;
                true
            };
            if (_args call _condition) exitWith {
                _args call _statement;
                true
            };
            false
        }, 
        {},
        [_condition, _statement, _args, _timeout, _timeoutCode, CBA_missionTime]
    ];
};

nil
