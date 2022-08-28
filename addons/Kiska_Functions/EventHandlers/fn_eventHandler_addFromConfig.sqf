/* ----------------------------------------------------------------------------
Function: KISKA_fnc_eventHandler_addFromConfig

Description:
    Adds a configed custom eventhandler.

Parameters:
    0: _entityToAddEventHandlerTo <ANY> - The entity to add the eventhandler to
	1: _config <CONFIG> - The config of the eventhandler
	2: _code <CODE or STRING> - What to execute when the eventhandler is called
        _thisScriptedEventHandler is available with the event id

Returns:
	<NUMBER> - The ID of the eventhandler

Examples:
    (begin example)
		private _eventID = [
            player,
            myConfig
        ] call KISKA_fnc_eventHandler_addFromConfig
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_eventHandler_addFromConfig";

params [
    "_entityToAddEventHandlerTo",
    ["_config",configNull,[configNull]],
    ["_code",{},["",{}]]
];

if (isNull _config) exitWith {
    ["Could not find config!",true] call KISKA_fnc_log;
    -1
};

if !([_entityToAddEventHandlerTo] call (compile getText(_config >> "entityCondition"))) exitWith {
    ["_entityToAddEventHandlerTo failed condition check!",true] call KISKA_fnc_log;
    -1
};

private _stateMachine_config = _config >> "stateMachine";
private _stateMachine_name = getText(_stateMachine_config >> "name");
private _stateMachine = localNamespace getVariable [_stateMachine_name,locationNull];
if (isNull _stateMachine) then {
    _stateMachine = [_stateMachine_config] call KISKA_fnc_eventhandler_createCBAStateMachine;
    localNamespace setVariable [_stateMachine_name,_stateMachine];
    _stateMachine setVariable ["KISKA_entity_eventhandlerCount_map",createHashMap];
};

private _entityList = _stateMachine getVariable ["CBA_statemachine_list", []];
if !(_entityToAddEventHandlerTo in _entityList) then {
    _entityList pushBack _entityToAddEventHandlerTo;
};

// tracking number of events for use when removing events
private _eventHandlerCount_map = _stateMachine getVariable "KISKA_entity_eventhandlerCount_map";
private _currentNumberOfEventsOnEntity = [_eventHandlerCount_map,_entityToAddEventHandlerTo,0] call KISKA_fnc_hashmap_get;

private _eventId = [
    _entityToAddEventHandlerTo,
    getText(_config >> "eventName"),
    _code
] call BIS_fnc_addScriptedEventhandler;

_currentNumberOfEventsOnEntity = _currentNumberOfEventsOnEntity + 1;
// update number of events on entity
[_eventHandlerCount_map,_entityToAddEventHandlerTo,_currentNumberOfEventsOnEntity] call KISKA_fnc_hashmap_set;


_eventId
