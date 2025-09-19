/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_createFromConfig

Description:
    Copied function `CBA_stateMachine_fnc_createFromConfig` from CBA.

    Creates a stateMachine instance from a given config. A stateMachine 
     loops over a given list of entities, processing only a single entity in the 
     list per frame.

    (begin config example)
        class MyAddon_Statemachine 
        {
            // Class properties have the same name as the corresponding function parameters
            // and code goes into strings.
            list = "allGroups select {!isPlayer leader _x}";
            skipNull = 1;

            // For all code properties:
            // If this string is a missionNamespace variable that is code (global function),
            // That function will be used as the code.
            // Otherwised the string will be compiled into a code.


            // States are just subclasses of the state machine
            class Initial 
            {
                whileStateActive = "";
                onStateEntered = "";
                onStateLeaving = "";

                // Transitions are also just subclasses of states
                class Aware 
                {
                    targetState = "Alert";
                    condition = "combatMode _this == 'YELLOW'";
                    onTransition = "{ \
                        _x setSkill ['spotDistance', ((_x skill 'spotDistance') * 1.5) min 1]; \
                        _x setSkill ['spotTime',     ((_x skill 'spotTime')     * 1.5) min 1]; \
                    } forEach (units _this);";
                };

                class InCombat : Aware
                {
                    condition = "combatMode _this == 'RED'";
                };
            };

            // Empty classes will also work if the state contains no transitions or onState code.
            class Alert 
            {};
        };
    (end)

Parameters:
    0: _config <CONFIG> - The configuration of the state machine.

Returns:
    <HASHMAP> - The hashamp the represents the state machine and contains infromation
        relevant to running it.

Example:
    (begin example)
        private _stateMachine = [
            missionConfigFile >> "My_Statemachine"
        ] call KISKA_fnc_stateMachine_createFromConfig;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_createFromConfig";

params [
    ["_config", configNull, [configNull]]
];

if (isNull _config) exitWith {
    ["Null config passed",true] call KISKA_fnc_log;
    nil
};

private _stateMachine = [
    compile (getText (_config >> "list")), 
    [_config >> "skipNull",true] call KISKA_fnc_getConfigData
] call KISKA_fnc_stateMachine_create;

private _stateClasses = configProperties [_config, "isClass _x", true];
_stateClasses apply {
    private _state = configName _x;
    private _args = [_stateMachine];
    private _stateClassConfig = _x;
    ["whileStateActive", "onStateEntered", "onStateLeaving"] apply {
        private _eventConfigValue = getText (_stateClassConfig >> _x);
        private _globalValue = missionNamespace getVariable [_eventConfigValue,-1];
        if (_globalValue isEqualType {}) then {
            _args pushBack _globalValue;
            continue;
        };

        _args pushBack (compile _eventConfigValue);
    };

    _args pushBack _state;
    _args call KISKA_fnc_stateMachine_addState;
};


// We need to add the transitions in a second loop to make sure the states exist already
_stateClasses apply {
    private _state = configName _x;
    (configProperties [_x, "isClass _x", true]) apply {
        private _transition = configName _x;
        private _targetState = _transition;
        if (isText (_x >> "targetState")) then {
            _targetState = getText (_x >> "targetState");
        };
        
        private _args = [_stateMachine,_state,_targetState];
        private _transitionClassConfig = _x;
        ["condition", "onTransition"] apply {
            private _configValue = getText (_transitionClassConfig >> _x);
            private _globalValue = missionNamespace getVariable [_configValue,-1];
            if (_globalValue isEqualType {}) then {
                _args pushBack _globalValue;
                continue;
            };

            _args pushBack (compile _configValue);
        };
        _args pushBack _transition;

        _args call KISKA_fnc_stateMachine_addTransition;
    };
};


_stateMachine
