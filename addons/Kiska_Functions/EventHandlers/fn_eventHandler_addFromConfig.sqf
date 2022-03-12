/* ----------------------------------------------------------------------------
Function: KISKA_fnc_eventHandler_addFromConfig

Description:
    Adds a configed custom eventhandler.

Parameters:
	0: _config <CONFIG> - The config of the eventhandler
	1: _addTo <ANY> - The entity to add the eventhandler to
	2: _code <CODE or STRING> - What to execute when the eventhandler is called

Returns:
	<NUMBER> - The ID of the eventhandler

Examples:
    (begin example)
		private _eventID = [
            player,

        ] call KISKA_fnc_eventHandler_addFromConfig
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_eventHandler_addFromConfig";

params [
    "_addTo",
    ["_config",configNull,[configNull]],
    ["_code",{},["",{}]]
];

if (isNull _config) exitWith {
    ["Could not find config!",true] call KISKA_fnc_log;
    -1
};

if !([_addTo] call (compile getText(_config >> "entityCondition"))) exitWith {
    ["_addTo failed condition check!",true] call KISKA_fnc_log;
    -1
};

private _stateMachine_config = _config >> "stateMachine";
private _stateMachine_name = getText(_stateMachine_config >> "name");
private _stateMachine = localNamespace getVariable [_stateMachine_name,locationNull];
if (isNull _stateMachine) then {
    _stateMachine = [_stateMachine_config] call CBA_stateMachine_fnc_createFromConfig;
    localNamespace setVariable [_stateMachine_name,_stateMachine];
    _stateMachine setVariable ["KISKA_entity_eventhandlerCount_map",createHashMap];
};

private _entityList = _stateMachine getVariable ["CBA_statemachine_list", []];
if !(_addTo in _entityList) then {
    _entityList pushBack _addTo;
};

// tracking number of events for use when removing events
/* private _eventHandlerCount_map = _stateMachine getVariable "KISKA_entity_eventhandlerCount_map"; */
/* private _currentNumberOfEvents = [_eventHandlerCount_map,_addTo,0] call KISKA_fnc_hashmap_get; */

private _eventId = [
    _addTo,
    getText(_config >> "eventName"),
    _code
] call BIS_fnc_addScriptedEventhandler;

/* _currentNumberOfEvents = _currentNumberOfEvents + 1; */
/* [_eventHandlerCount_map,_addTo,_currentNumberOfEvents] call KISKA_fnc_hashmap_set; */


_eventId
