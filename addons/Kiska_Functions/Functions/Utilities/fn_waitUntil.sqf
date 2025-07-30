/* ----------------------------------------------------------------------------
Function: KISKA_fnc_waitUntil

Description:
    Waitunil that allows variable evaluation time instead of frame by frame.

Parameters:
    0: _condition <CODE, STRING, or ARRAY> - Code that must evaluate as a `BOOL`.
        If `(_interval <= 0) AND (_unscheduled isEqualTo true)`, this will only accept CODE
        or `STRING` as an arguement for performance reasons and `_parameters` will be available in `_this`.
        (See KISKA_fnc_callBack)
    1: _onConditionMet <CODE, STRING, or ARRAY> - The code to execute upon condition being reached.
        (See KISKA_fnc_callBack)
    2: _interval <NUMBER> - How often to check the condition
    3: _parameters <ARRAY> - An array of local parameters that can be accessed with _this
    4: _unscheduled <BOOL> - Run in unscheduled environment

Returns:
    NOTHING

Examples:
    (begin example)
        private _variable = 123;
        [
            {
                params ["_variable"];
                true
            },
            {
                params ["_variable"];
                hint "wait";
            },
            0.5,
            [_variable],
            true
        ] call KISKA_fnc_waitUntil;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_waitUntil";

params [
    ["_condition",{},[{},"",[]]],
    ["_onConditionMet",{},[{},"",[]]],
    ["_interval",0.5,[123]],
    ["_parameters",[],[[]]],
    ["_unscheduled",true,[true]]
];


private _isPerFrame = _interval <= 0;
if (
    _unscheduled AND
    _isPerFrame AND
    (_condition isEqualType [])
) exitWith {
    [
        "Unscheduled, perframe waituntil will only support CODE or STRING as an arguement",
        true
    ] call KISKA_fnc_log;
    nil
};


if (_condition isEqualType "") then {
    _condition = compileFinal _condition;
};
if (_onConditionMet isEqualType "") then {
    _onConditionMet = compileFinal _onConditionMet;
};


/* -----------------------------------
    Perframe unscheduled
----------------------------------- */
if (_unscheduled AND _isPerframe) exitWith {
    [
        {
            params ["_parameters","","_condition"];
            _parameters call _condition
        },
        {
            params ["_parameters","_onConditionMet",""];
            [_parameters,_onConditionMet] call KISKA_fnc_callBack;
        },
        [_parameters,_onConditionMet,_condition]
    ] call CBA_fnc_waitUntilAndExecute;
};


/* -----------------------------------
    Unscheduled with interval
----------------------------------- */
if (_unscheduled) exitWith {
    [
        {
            (_this select 0) params [
                "_condition",
                "_onConditionMet",
                "_interval",
                "_parameters"
            ];

            private _conditionMet = [_parameters,_condition] call KISKA_fnc_callBack;
            if (_conditionMet) exitWith {
                [_parameters,_onConditionMet] call KISKA_fnc_callBack;

                private _id = _this select 1;
                [_id] call CBA_fnc_removePerFrameHandler;
            };
        },
        _interval,
        _this
    ] call CBA_fnc_addPerFrameHandler;

    nil
};


/* -----------------------------------
    Scheduled
----------------------------------- */
[_interval,_onConditionMet,_condition,_parameters] spawn {
    params ["_interval","_onConditionMet","_condition","_parameters"];

    waitUntil {
        sleep _interval;
        private _conditionMet = [_parameters,_condition] call KISKA_fnc_callBack;
        if (_conditionMet) exitWith {
            [_parameters,_onConditionMet] call KISKA_fnc_callBack;
            true
        };

        false
    };

};


nil
