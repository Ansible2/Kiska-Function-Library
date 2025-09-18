/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_create

Description:
    Copied function `CBA_stateMachine_fnc_create` from CBA.

    Creates a stateMachine instance. A stateMachine loops over a given list of
     entities, processing only a single entity in the list per frame.

Parameters:
    0: _list <CODE | ARRAY> - List of anything over which the state machine will
        iterate over. The list contents must support `setVariable`. If of type CODE, 
        the code must return a valid list and will be run after each each list cycle.
    1: _skipNull <BOOL> Default: `false` - Skip null entities within the list.

Returns:
    <HASHMAP> - The hashamp the represents the state machine and contains infromation
        relevant to running it.

Example:
    (begin example)
        private _stateMachine = [
            [MyObject_1,MyObject_2],
            true
        ] call KISKA_fnc_stateMachine_create;
    (end)

    (begin example)
        private _stateMachine = call KISKA_fnc_stateMachine_create;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_create";

params [
    ["_list", [], [[], {}]],
    ["_skipNull", false, [true]]
];

if (isNil "KISKA_stateMachines") then { KISKA_stateMachines = createHashMap };

private _updateCode = {};
if (_list isEqualType {}) then {
    _updateCode = _list;
    _list = [] call _updateCode;
};

if (_skipNull) then {
    _list = _list select {!isNull _x};
};


private _guid = ["KISKA_stateMachine"] call KISKA_fnc_generateUniqueId;
private _stateMachine = createHashMapFromArray [
    ["nextUniqueStateID",0],
    ["currentListIndex",0],
    ["states",[]],
    ["performanceCounters",[]],
    ["list",_list],
    ["skipNull",_skipNull],
    ["updateCode",_updateCode],
    ["guid",_guid]
];

KISKA_stateMachines set [_guid,_stateMachine];

if (isNil { localNamespace getVariable "KISKA_stateMachine_frameHandlerId" }) then {
    private _eventId = addMissionEventHandler ["EachFrame", {
        call KISKA_fnc_stateMachine_onEachFrame
    }];
    localNamespace setVariable ["KISKA_stateMachine_frameHandlerId",_eventId];
};


_stateMachine
