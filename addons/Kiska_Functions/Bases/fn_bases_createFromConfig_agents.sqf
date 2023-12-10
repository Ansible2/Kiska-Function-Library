/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_agents

Description:
    Spawns a configed KISKA bases' agents.

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
    ["A null _baseConfig was passed",true] call KISKA_fnc_log;
    []
};


/* ----------------------------------------------------------------------------
    _fn_getPropertyValue
---------------------------------------------------------------------------- */
private _fn_getPropertyValue = {
    params [
        ["_property","",[""]],
        ["_agentsSetConfig",configNull,[configNull]],
        "_default",
        ["_isBool",false,[false]],
        ["_canSelectFromSetRoot",true,[false]],
        ["_canSelectFromBaseRoot",true,[false]]
    ];

    private _agentsSetConditionalValue = [_agentsSetConfig >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
    if !(isNil "_agentsSetConditionalValue") exitWith { _agentsSetConditionalValue };

    private _agentsSetPropertyConfigPath = _agentsSetConfig >> _property;
    if !(isNull _agentsSetPropertyConfigPath) exitWith {
        [_agentsSetPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
    };

    private "_propertyValue";
    if (_canSelectFromSetRoot) then {
        private _agentsSectionConfigPath = _baseConfig >> "agents";
        private _agentsSectionConditionalValue = [_agentsSectionConfigPath >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
        if !(isNil "_agentsSectionConditionalValue") exitWith { _agentsSectionConditionalValue };

        private _agentsSectionPropertyConfigPath = _agentsSectionConfigPath >> _property;
        if !(isNull _agentsSectionPropertyConfigPath) then {
            _propertyValue = [_agentsSectionPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
        };
    };

    if (_canSelectFromBaseRoot AND (isNil "_propertyValue")) then {
        private _baseRootConditionalValue = [_baseConfig >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
        if !(isNil "_baseRootConditionalValue") exitWith { _baseRootConditionalValue };

        private _baseSectionPropertyConfigPath = _baseConfig >> _property;
        if !(isNull _baseSectionPropertyConfigPath) exitWith {
            _propertyValue = [_baseSectionPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
        };
    };

    if (isNil "_propertyValue") then {
        _default
    } else {
        _propertyValue
    };
};




private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_agentsList = _baseMap get "agent list";

private _agentsConfig = _baseConfig >> "agents";
private _agentClasses = configProperties [_agentsConfig >> "sets","isClass _x"];


/* ----------------------------------------------------------------------------

    Create Agents

---------------------------------------------------------------------------- */
_agentClasses apply {
    private _agentsSetConfig = _x;

    private _spawnPositions = [
        "spawnPositions",
        _agentsSetConfig,
        [],
        false,
        false,
        false
    ] call _fn_getPropertyValue;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = [_spawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };
    if (_spawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };
    _spawnPositions = [_spawnPositions] call CBA_fnc_shuffle;


    private _numberOfSpawns = count _spawnPositions;
    if ((_numberOfSpawns < _numberOfAgents) OR (_numberOfAgents isEqualTo -1)) then {
        _numberOfAgents = _numberOfSpawns;
    };


    private _unitClasses = ["unitClasses", _agentsSetConfig, []] call _fn_getPropertyValue;
    if (_unitClasses isEqualType "") then {
        _unitClasses = [[_agentsSetConfig],_unitClasses] call KISKA_fnc_callBack;
    };
    if (_unitClasses isEqualTo []) then {
        [["Found no unitClasses to use for KISKA base class: ",_agentsSetConfig], true] call KISKA_fnc_log;
        continue;
    };

    
    private _side = ["side", _agentsSetConfig, 0] call _fn_getPropertyValue;
    _side = _side call BIS_fnc_sideType;


    private _numberOfUnits = [
        "numberOfUnits", 
        _agentsSetConfig, 
        -1,
        false,
        true,
        false
    ] call _fn_getPropertyValue;
    if (_numberOfUnits isEqualType "") then {
        _numberOfUnits = [[_agentsSetConfig,_spawnPositions],_numberOfUnits,false] call KISKA_fnc_callBack;
    };


    private _enableDynamicSim = ["dynamicSim", _agentsSetConfig, true, true] call _fn_getPropertyValue;


    private _agents = [];
    for "_i" from 0 to (_numberOfUnits - 1) do {
        private _spawnPosition = _spawnPositions select _i;
        private _direction = 0;
        if (_spawnPosition isEqualType objNull) then {
            _direction = getDir _spawnPosition;
        };
        if ((_spawnPosition isEqualType []) AND {(count _spawnPosition) > 3}) then {
            _direction = _spawnPosition deleteAt 3;
        };

        private _agent = createAgent [
            [_unitClasses,""] call KISKA_fnc_selectRandom,
            _spawnPosition,
            [],
            0,
            "CAN_COLLIDE"
        ];

        _agent enableDynamicSimulation _enableDynamicSim;
        _agent setDir _direction;
        _agents pushBack _agent;
    };

    [_agentsSetConfig,_agents] call KISKA_fnc_bases_initAmbientAnimFromClass;


    private _onUnitsCreated = [
        "onUnitsCreated", 
        _agentsSetConfig, 
        "",
        false,
        true,
        false
    ] call _fn_getPropertyValue;
    if (_onUnitsCreated isNotEqualTo "") then {
        [[_agentsSetConfig,_agents],_onUnitsCreated,false] call KISKA_fnc_callBack;
    };

    _base_agentsList append _agents;
};


_baseMap
