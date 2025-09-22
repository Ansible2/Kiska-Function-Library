/* ----------------------------------------------------------------------------
Function: KISKA_fnc_eventHandler_remove

Description:
    Removes a configed custom eventhandler.

    Worth noting that this will still return `true` even after the event has been
     removed as BIS_fnc_removeScriptedEventHandler essentially checks that the event
     isn't one that never could have existed.

Parameters:
    0: _entity <ANY> - The config of the eventhandler
    1: _eventConfig <CONFIG> - The eventhandler config path
    2: _id <NUMBER> - The event to remove

Returns:
    <BOOL> - `true` if removed, `false` if it never existed

Examples:
    (begin example)
        private _removed = [
            player,
            configFile >> "KISKA_EventHandlers" >> "KISKA_combatBehaviourChangedEvent",
            0
        ] call KISKA_fnc_eventHandler_remove
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_eventHandler_remove";

params [
    "_removeFrom",
    ["_eventConfig",configNull,[configNull]],
    ["_id",-1,[123]]
];

if (isNull _eventConfig) exitWith {
    ["_eventConfig is null config!",true] call KISKA_fnc_log;
    false
};

private _stateMachine_name = getText(_eventConfig >> "stateMachine" >> "name");
private _eventhandlerStateMachineMap = [
    localNamespace,
    "KISKA_eventHandlers_stateMachineMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _stateMachine = _eventhandlerStateMachineMap get _stateMachine_name;
if (isNil "_stateMachine") then {
    [["Statemachine: ", _stateMachine_name," has not been instantiated yet!"],false] call KISKA_fnc_log;
    false
};


private _eventName = getText(_eventConfig >> "eventName");
private _removed = [_removeFrom, _eventName, _id] call BIS_fnc_removeScriptedEventHandler;

// remove from statemachine list if no events are left for this machine
if (_removed) then {
    private _eventCountMap = _stateMachine get "KISKA_eventHandlers_entityCount_map";
    private _numberOfEvents = [_eventCountMap,_removeFrom] call KISKA_fnc_hashmap_get;

    _numberOfEvents = _numberOfEvents - 1;

    if (_numberOfEvents isEqualTo 0) then {
        [_eventCountMap,_removeFrom] call KISKA_fnc_hashmap_deleteAt;

        private _entityList = _stateMachine get "list";
        _entityList deleteAt (_entityList find _removeFrom);
    };
};


_removed
