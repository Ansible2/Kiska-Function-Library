/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addEventhandler_behaviour

Description:
	Makes a helicopter land at a given position.

Parameters:
	0: _entity <OBJECT or GROUP> - The unit or group to add the event to
	1: _code <CODE or STRING> - Exectute on change

Returns:
	<NUMBER> - Index of eventhandler

Examples:
    (begin example)
		[

        ] call KISKA_fnc_addEventhandler_behaviour;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addEventhandler_behaviour";

params [
    ["_entity",objNull,[grpNull,objNull]],
    ["_code",{},["",{}]]
];

if (isNull _entity) exitWith {
    ["_entity is null!",true] call KISKA_fnc_log;
    -1
};

if (_code isEqualTo {} OR (_code isEqualTo "")) {
    ["_code is empty, will no be added!"] call KISKA_fnc_log;
    -1
};

private _stateMachine = localNamespace getVariable ["KISKA_behaviourStateMachine",locationNull];
if (isNull _stateMachine) then {
    _stateMachine = call KISKA_fnc_createBehaviourStateMachine;
};

if (isNil {localNamespace getVariable "KISKA_behaviourStateMachine_list"}) then {
    localNamespace setVariable ["KISKA_behaviourStateMachine_list", []];
};
private _entities = localNamespace getVariable ["KISKA_behaviourStateMachine_list",[]];
_entities pushBackUnique _entity;


[_entity,BEHAVIOUR_SCRIPTED_EVENT_NAME,_code] call BIS_fnc_addScriptedEventHandler;
