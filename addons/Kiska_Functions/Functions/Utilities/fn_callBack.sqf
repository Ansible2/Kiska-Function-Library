/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callBack

Description:
    Standerdizes a means of passing a callback function to another function
    along with custom arguments.

Parameters:
    0: _defaultArgs <ANY> - Default arguements. These would be what a function
        writer would put inside of their code as arguements that will always be passed
        in the _this magic variable
    1: _callBackFunction <CODE, STRING, ARRAY> - Code to call, compile and call, and/or
        arguements to pass to the code (in _thisArgs variable). Array is formatted as
        [<args array>,code or string (to compile)]
    2: _runInScheduled <BOOL> - Spawns the code in a scheduled thread

Returns:
    <ANY> - Whatever the callback function returns or scripthandle if run in scheduled

Examples:
    (begin example)
        [
            [],
            [
                // hint player
                [player],
                {hint (_thisArgs select 0)}
            ]
        ] call KISKA_fnc_callBack
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callBack";

params [
    ["_defaultArgs",[]],
    ["_callBackFunction",{},[[],"",{}]],
    ["_runInScheduled",false,[true]]
];


private "_actualCallBackFunction";
private _thisArgs = [];
call {
    if (_callBackFunction isEqualType {}) exitWith {
        _actualCallBackFunction = _callBackFunction;
    };

    if (_callBackFunction isEqualType []) exitWith {
        if (_callBackFunction isEqualTypeParams [[],""]) exitWith {
            _thisArgs = _callBackFunction select 0;
            _actualCallBackFunction = compile (_callBackFunction select 1);
        };

        if (_callBackFunction isEqualTypeParams [[],{}]) exitWith {
            _thisArgs = _callBackFunction select 0;
            _actualCallBackFunction = _callBackFunction select 1;
        };
    };

    if (_callBackFunction isEqualType "") exitWith {
        _actualCallBackFunction = compile _callBackFunction;
    };
};

if (isNil "_actualCallBackFunction") exitWith {
    [
        [
            "_callBackFunction improperly configured:",
            _callBackFunction
        ],
        true
    ] call KISKA_fnc_log;
    nil
};

if !(_runInScheduled) exitWith {
    [
        {
            params ["_defaultArgs","_thisArgs","_actualCallBackFunction"];
            _defaultArgs call _actualCallBackFunction;
        },
        [
            _defaultArgs,
            _thisArgs,
            _actualCallBackFunction
        ]
    ] call KISKA_fnc_CBA_directCall;
};


[
    _defaultArgs,
    _thisArgs,
    _callBackFunction
] spawn {
    params ["_defaultArgs","_thisArgs","_actualCallBackFunction"];
    _defaultArgs call _actualCallBackFunction;
};
