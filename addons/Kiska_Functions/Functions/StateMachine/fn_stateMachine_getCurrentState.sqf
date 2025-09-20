/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_getCurrentState

Description:
    Copied function `CBA_statemachine_fnc_getCurrentState` from CBA.

    Gets the current state of the given item in the state machine.

Parameters:
    0: _listItem <NAMESPACE, OBJECT, GROUP, TEAMMEMBER, TASK, LOCATION> - 
        The item in the state machine to get the state of.
    1: _stateMachineMap <HASHMAP> - The state machine's hashmap.

Returns:
    <STRING> - State of the given item, will be an empty string if the item
        is not found in the state machine.

Example:
    (begin example)
        private _currentState = [
            player,
            _stateMachine
        ] call KISKA_fnc_stateMachine_getCurrentState;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_getCurrentState";

params [
    ["_listItem", objNull, [missionNamespace, objNull, grpNull, teamMemberNull, taskNull, locationNull]],
    ["_stateMachineMap", nil, [createHashMap]]
];

if (isNil "_stateMachineMap") exitWith { "" };

private _guid = _stateMachineMap get "guid";
private _currentItemStateVar = ["KISKA_stateMachine_state",_guid] joinString "-";
_listItem getVariable [_currentItemStateVar,""]
