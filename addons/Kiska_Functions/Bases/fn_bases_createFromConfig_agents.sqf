/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_infantry

Description:
	Spawns a configed KISKA bases' infantry.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

Examples:
    (begin example)
		[
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_createFromConfig_agents;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_agents";

params [
    ["_baseConfig",configNull,["",configNull]]
];


if (_baseConfig isEqualType "") then {
    _baseConfig = missionConfigFile >> "KISKA_Bases" >> _baseConfig;
};
if (isNull _baseConfig) exitWith {
    [[_baseConfig, " is a null config path"],true] call KISKA_fnc_log;
    []
};


private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_agentsList = _baseMap get "agent list";

/* ----------------------------------------------------------------------------

    Helper functions

---------------------------------------------------------------------------- */
private _agentsConfig = _baseConfig >> "agents";
private _agentClasses = configProperties [_agentsConfig,"isClass _x"];
private _agentClassUnitClasses = getArray(_agentsConfig >> "infantryClasses");

private _baseUnitClasses = getArray(_baseConfig >> "infantryClasses");
private _fn_getUnitClasses = {
    params ["_configClass"];

    private _unitClasses = getArray(_configClass >> "infantryClasses");
    if (_unitClasses isEqualTo []) then {
        if (_agentClassUnitClasses isNotEqualTo []) then {
            _unitClasses = _agentClassUnitClasses;
        } else {
            _unitClasses = _baseUnitClasses;
        };
    };


    _unitClasses
};



/* ----------------------------------------------------------------------------

    Create Infantry

---------------------------------------------------------------------------- */


_infantryClasses apply {
    private _classConfig = _x;
    private _spawnPositions = (_classConfig >> "positions" ) call BIS_fnc_getCfgData;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = [_spawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };

    if (_spawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };

    private _unitClasses = [_x] call _fn_getUnitClasses;
    private _numberOfAgents = getNumber(_classConfig >> "numberOfAgents");
    _spawnPositions = [_spawnPositions] call CBA_fnc_shuffle;
    private _agents = [];

    for "_i" from 0 to (_numberOfAgents - 1) do {
        private _agent = createAgent [
            selectRandom _unitClasses,
            _spawnPositions select _i,
            [],
            0,
            "CAN_COLLIDE"
        ];

        _agents pushBack _agent;
    };


    private _animateClass = _classConfig >> "ambientAnim";
    if !(isNull _animateClass) then {
        private _animationSet = getText(_animateClass >> "animationSet");
        if (_animationSet isEqualTo "") then {_equipmentLevel = "STAND"};

        private _equipmentLevel = getText(_animateClass >> "equipmentLevel");
        if (_equipmentLevel isEqualTo "") then {_equipmentLevel = "ASIS"};

        private _interpolate = [_x >> "interpolate"] call BIS_fnc_getCfgDataBool;
        // attachToLogic in BIS_fnc_ambientAnim is default true,
        // this ensures that intention if dontAttachToLogic is undefined in the config
        private _attachToLogic = !([_x >> "dontAttachToLogic"] call BIS_fnc_getCfgDataBool);
        _agents apply {
            [
                _x,
                _animationSet,
                _equipmentLevel,
                objNull,
                _interpolate,
                _attachToLogic
            ] call BIS_fnc_ambientAnim;
        };
    };

    private _onAgentsCreated = getText(_classConfig >> "onAgentsCreated");
    if (_onUnitsCreated isNotEqualTo "") then {
        _onAgentsCreated = compile _onAgentsCreated;
        [
            _onAgentsCreated,
            [_agents]
        ] call CBA_fnc_directCall;
    };

    _base_agentsList append _agents;
};


_baseMap
