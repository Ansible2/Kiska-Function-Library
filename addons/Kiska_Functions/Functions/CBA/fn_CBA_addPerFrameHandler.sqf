/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_addPerFrameHandler

Description:
    Copied version of the CBA system that enables `CBA_fnc_addPerFrameHandler`.

    Executes a piece of code at the given interval.

Parameters:
    0: _function <CODE> - Code that will execute that the given interval.
    1: _delay <NUMBER> Default: `0` - The number of seconds between each execution.
        If `0`, the code will be executed every frame.
    2: _args <ANY> Default: `[]` - Parameters passed to the function executing. This will be the 
        same reference every execution.

Returns:
    <NUMBER> - An id or handle that can be used to modify and/or remove the 
        handler in the future.

Example:
    (begin example)
        private _handle = [
            {
                player sideChat format ["every frame! _this: %1", _this];
            },
            0,
            ["some","params",1,2,3]
        ] call KISKA_fnc_CBA_addPerFrameHandler;
    (end)

Author(s):
    Nou & Jaynus, donated from ACRE project code for use by the community; commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_addPerFrameHandler";

params [
    ["_function", {}, [{}]], 
    ["_delay", 0, [0]], 
    ["_args", []]
];

if (_function isEqualTo {}) exitWith {-1};

if (isNil "KISKA_CBA_PFHhandles") then {
    KISKA_CBA_PFHhandles = [];
};

if (count KISKA_CBA_PFHhandles >= 9999999) exitWith {
    ["Maximum amount of per frame handlers reached!",true] call KISKA_fnc_log;
    diag_log _function;
    -1
};

private _handle = KISKA_CBA_PFHhandles pushBack (count KISKA_CBA_perFrameHandlerArray);

KISKA_CBA_perFrameHandlerArray pushBack [
    _function, 
    _delay, 
    diag_tickTime, 
    diag_tickTime, 
    _args, 
    _handle
];

_handle

