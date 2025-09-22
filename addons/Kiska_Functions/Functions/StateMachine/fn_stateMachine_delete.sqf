/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_delete

Description:
    Copied function `CBA_stateMachine_fnc_delete` from CBA.

    Stops and deletes a state machine.

Parameters:
    0: _stateMachine <HASHMAP> - The state machine to delete.

Returns:
    NOTHING

Example:
    (begin example)
        [_stateMachine] call KISKA_fnc_stateMachine_delete;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_delete";

params [
    ["_stateMachine", nil, [createHashMap]]
];

if (isNil "KISKA_stateMachines") exitWith {};

if (isNil "_stateMachine") exitWith {
    ["_stateMachine is nil",true] call KISKA_fnc_log;
    nil
};

KISKA_stateMachines deleteAt (_stateMachine getOrDefaultCall ["guid",{""}]);


nil
