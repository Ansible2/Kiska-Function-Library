/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_addTransition

Description:
    Copied function `CBA_stateMachine_fnc_addTransition` from CBA.

    Creates a transition between two states.

Parameters:
    0: _stateMachineMap <HASHMAP> - The state machine's hashmap.
    1: _originalState <STRING> - The state that the transition will originate from.
    2: _targetState <STRING> - The state that the transition will be going towards.
    3: _condition <CODE> - Condition under which the transition will happen. Should
        return BOOL.
    4: _onTransition <CODE> Default: `{}` - code that gets executed once transition 
        happens.
    5: _transitionName <CODE> Default: `"NONAME"` - Name for this specific transition.

Returns:
    NOTHING

Example:
    (begin example)
        [
            _stateMachine, 
            "initial", 
            "end", 
            {true}, 
            {
                systemChat format [
                    "%1 transitioned from %2 to %3 via %4.",
                    _this, _thisOrigin, _thisTarget, _thisTransition
                ];
            }, 
            "dummyTransition"
        ] call KISKA_fnc_stateMachine_addTransition;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_addTransition";

params [
    ["_stateMachine", nil, [createHashMap]],
    ["_originalState", "", [""]],
    ["_targetState", "", [""]],
    ["_condition", {}, [{}]],
    ["_onTransition", {}, [{}]],
    ["_transitionName", "NONAME", [""]]
];

private _states = _stateMachine get "states";
_originalState = toUpperANSI _originalState;
if !(_originalState in _states) exitWith {
    [
        [
            "_originalState ",_originalState,
            " has not been added to this state machine"
        ],
        true
    ] call KISKA_fnc_log;
    nil
};

_targetState = toUpperANSI _targetState;
if !(_targetState in _states) exitWith {
    [
        [
            "_targetState ",_targetState,
            " has not been added to this state machine"
        ],
        true
    ] call KISKA_fnc_log;
    nil
};

if (_condition isEqualTo {}) exitWith {
    ["Empty _condition used, must return a boolean!",true] call KISKA_fnc_log;
    nil
};

private _transitions = _stateMachine getOrDefaultCall [
    [_originalState,"transitions"] joinString "_",
    { [] },
    true
];
_transitions pushBack [_transitionName, _condition, _targetState, _onTransition];


nil
