/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_manualTransition

Description:
    Copied function `CBA_statemachine_fnc_manualTransition` from CBA.

    Gets the current state of the given item in the state machine.

Parameters:
    0: _listItem <NAMESPACE, OBJECT, GROUP, TEAMMEMBER, TASK, LOCATION> - 
        The item in the state machine to get the state of.
    1: _stateMachineMap <HASHMAP> - The state machine's hashmap.
    2: _thisOrigin <STRING> Default: `""` - The state that the transition is
        supposed to be **coming from**. If this state was added to the state machine,
        its `onStateLeaving` function will be called.
    3: _thisTarget <STRING> Default: `""` - The state that the transition is
        supposed to be **going to**. If this state was added to the state machine,
        its `onStateEntered` function will be called.
    4: _onTransition <CODE> Default: `{}` - The transition code to be executed.
        
        Parameters:
        - `_this` - Same as `_listItem`.
        - `_thisOrigin`: <STRING> - The name of the previous state.
        - `_thisTransition`: <STRING> - The name of the transition that was completed.
        - `_thisTarget`: <STRING> - The name of the state that was entered.

    5: _thisTransition <STRING> Default: `"MANUAL"` - The name of this transition.

Returns:
    NOTHING

Example:
    (begin example)
        [
            _stateMachineMap, 
            "initial", 
            "end", 
            {
                systemChat format [
                    "%1 transitioned from %2 to %3 manually.",
                    _this, _thisOrigin, _thisTarget
                ];
            }, 
            "dummyTransition"
        ] call KISKA_fnc_stateMachine_manualTransition;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_manualTransition";


params [
    ["_listItem", objNull, [missionNamespace, objNull, grpNull, teamMemberNull, taskNull, locationNull]],
    ["_stateMachineMap", nil, [createHashMap]],
    ["_thisOrigin", "", [""]],
    ["_thisTarget", "", [""]],
    ["_onTransition", {}, [{}]],
    ["_thisTransition", "MANUAL", [""]]
];

if (isNil "_stateMachineMap") exitWith {
    ["Undefined state machine passed",true] call KISKA_fnc_log;
    nil
};

private _thisState = _thisOrigin;
private _guid = _stateMachineMap get "guid";

_listItem call (_stateMachineMap get ([_thisOrigin,"onStateLeaving"] joinString "_"));
_listItem call _onTransition;
_listItem setVariable [
    ["KISKA_stateMachine_state",_guid] joinString "-", 
    _thisTarget
];
_listItem call (_stateMachineMap get ([_thisTarget,"onStateEntered"] joinString "_"));


nil
