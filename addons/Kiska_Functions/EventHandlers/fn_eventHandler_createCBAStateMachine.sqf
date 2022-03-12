/* ----------------------------------------------------------------------------
Function: KISKA_fnc_createCBAStateMachineFromConfig

Description:
    Adds a configed custom eventhandler

Parameters:
	0: _config <CONFIG> - The config of the statemachine

Returns:
	<LOCATION> - The statemachine

Examples:
    (begin example)
		_statemachine = [myConfig] call KISKA_fnc_createCBAStateMachineFromConfig
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_createCBAStateMachineFromConfig";

params [
    ["_config", configNull, [configNull]]
];

if (isNull _config) exitWith {
    ["_config passed was null!",true] call KISKA_fnc_log;
    locationNull;
};

private _skipNull = [_config >> "skipNull"] call BIS_fnc_getCfgDataBool;
private _stateMachine = [[], _skipNull] call CBA_stateMachine_fnc_create;

(configProperties [_config, "isClass _x", true]) apply {
    private _stateName = configName _x;
    [
        _stateMachine,
        compile (getText(_x >> "onState")),
        compile (getText(_x >> "onStateEntered")),
        compile (getText(_x >> "onStateLeaving")),
        _stateName
    ] call CBA_stateMachine_fnc_addState;

};

// We need to add the transitions in a second loop to make sure the states exist already
(configProperties [_config, "isClass _x", true]) apply {
    private _stateName = configName _x;

    (configProperties [_x, "isClass _x", true]) apply {
        private _transitionName = configName _x;
        private _targetState = _transitionName;
        if (isText (_x >> "targetState")) then {
            _targetState = getText (_x >> "targetState");
        };

        private _condition = compile (getText(_x >> "condition"));
        private _onTransition = compile (getText(_x >> "onTransition"));
        private _events = getArray (_x >> "events");

        if (_events isEqualTo []) then {
            [
                _stateMachine,
                _stateName,
                _targetState,
                _condition,
                _onTransition,
                _transitionName
            ] call CBA_stateMachine_fnc_addTransition;

        } else {
            [
                _stateMachine,
                _stateName,
                _targetState,
                _events,
                _condition,
                _onTransition,
                _transitionName
            ] call CBA_stateMachine_fnc_addEventTransition;
        };

    };

};


_stateMachine
