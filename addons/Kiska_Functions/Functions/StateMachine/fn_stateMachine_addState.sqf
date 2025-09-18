/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_addState

Description:
    Copied function `CBA_statemachine_fnc_addState` from CBA.

    Adds a state to a state machine.

Parameters:
    0: _stateMachineMap <HASHMAP> - The state machine's hashmap.
    1: _whileStateActive <CODE> Default: `{}` - Code that is executed while the
        state is active (frequency depends on amount of objects active in the
        state machine).

        Parameters:
        - `_this` - Whatever the current item in the list is.
        - `_thisState`: <STRING> - The name of the state.

    2: _onStateEntered <CODE> Default: `{}` - Code that is executed once the state
        has been entered. After a transition is completed (also once for the
        intial state).

        Parameters:
        - `_this` - Whatever the current item in the list is.
        - `_thisOrigin`: <STRING> - The name of the previous state.
        - `_thisTransition`: <STRING> - The name of the transition that was completed.
        - `_thisTarget`: <STRING> - The name of the state that was entered.

    3: _onStateLeaving <CODE> Default: `{}` - Code that is executed once when 
        exiting the state, before the transition is started.

        Parameters:
        - `_this` - Whatever the current item in the list is.
        - `_thisOrigin`: <STRING> - The name of the previous state.
        - `_thisTransition`: <STRING> - The name of the transition that was completed.
        - `_thisTarget`: <STRING> - The name of the state that was entered.

    4: _stateId <STRING> Default: `""` - A unique identifier for the state. If an 
        empty string, `KISKA_fnc_generateUniqueId` will be used to create an id. The
        id will be all caps.

Returns:
    <STRING> - The state's id or an empty string if encountering an error.

Example:
    (begin example)
        private _stateId = [_stateMachineMap, {}] call CBA_statemachine_fnc_addState;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_addState";

params [
    ["_stateMachineMap", nil, [createHashMap]],
    ["_whileStateActive", {}, [{}]],
    ["_onStateEntered", {}, [{}]],
    ["_onStateLeaving", {}, [{}]],
    ["_stateId", "", [""]]
];

if (_stateId isEqualTo "") then {
    _stateId = ["KISKA_stateMachine_state"] call KISKA_fnc_generateUniqueId;
};

private _states = _stateMachineMap getOrDefaultCall ["states",{[]},true];
_stateId = toUpperANSI _stateId;
if (_stateId in _states) exitWith {
    [["_stateId ",_stateId," already exists in the state machine"],true] call KISKA_fnc_log;
    ""
};

_states pushBack _stateId;
[
    ["whileStateActive", _whileStateActive],
    ["onStateEntered", _onStateEntered],
    ["onStateLeaving", _onStateLeaving],
    ["transitions", []]
] apply {
    _x params ["_keyAppend","_value"];
    _stateMachineMap set [[_stateId,_keyAppend] joinString "_", _value];
};


if (isNil {_stateMachineMap get "initialState"}) then {
    _stateMachineMap set ["initialState",_stateId];
    private _guid = _stateMachineMap get "guid";
    KISKA_stateMachines set [_guid,_stateMachineMap];
};

_name
