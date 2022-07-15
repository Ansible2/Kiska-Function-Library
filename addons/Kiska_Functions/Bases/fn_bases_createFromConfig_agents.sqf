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

    Create Agents

---------------------------------------------------------------------------- */
_agentClasses apply {
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
    private _numberOfSpawns = count _spawnPositions;
    if (_numberOfSpawns < _numberOfAgents OR (_numberOfAgents isEqualTo -1)) then {
        _numberOfAgents = _numberOfSpawns;
    };

    _spawnPositions = [_spawnPositions] call CBA_fnc_shuffle;
    private _agents = [];

    private _placement = "CAN_COLLIDE";
    private _placementConfigValue = getText(_x >> "placement");
    if (_placementConfigValue isNotEqualTo "") then {
        _placement = _placementConfigValue;
    };

    for "_i" from 0 to (_numberOfAgents - 1) do {
        private _spawnPosition = _spawnPositions select _i;
        private _direction = 0;
        if (_spawnPosition isEqualType objNull) then {
            _direction = getDir _spawnPosition;
        };
        if (_spawnPosition isEqualType [] AND {count _spawnPosition > 3}) then {
            _direction = _spawnPosition deleteAt 3;
        };

        private _agent = createAgent [
            selectRandom _unitClasses,
            _spawnPosition,
            [],
            0,
            _placement
        ];


        _agent setDir _direction;
        _agents pushBack _agent;
    };

    /* ---------------------------------
        Animate
    --------------------------------- */
    private _animateClass = _classConfig >> "ambientAnim";
    if !(isNull _animateClass) then {
        private _animationSet = (_animateClass >> "animationSet") call BIS_fnc_getCfgData;
        if (_animationSet isEqualTo "") then {_animationSet = "STAND"};
        private _randomAnimationSet = _animationSet isEqualType [];

        private _equipmentLevel = (_animateClass >> "equipmentLevel") call BIS_fnc_getCfgData;
        if (_equipmentLevel isEqualTo "") then {_equipmentLevel = "ASIS"};
        private _randomEquipmentLevel = _equipmentLevel isEqualType [];

        private _interpolate = [_x >> "interpolate"] call BIS_fnc_getCfgDataBool;
        // attachToLogic in BIS_fnc_ambientAnim is default true,
        // this ensures that intention if dontAttachToLogic is undefined in the config
        private _attachToLogic = !([_x >> "dontAttachToLogic"] call BIS_fnc_getCfgDataBool);
        _agents apply {
            private _equipment = _equipmentLevel;
            private _animationType = _animationSet;
            if (_randomAnimationSet) then {_animationType = selectRandom _animationSet};
            if (_randomEquipmentLevel) then {_equipment = selectRandom _equipmentLevel};

            [
                _x,
                _animationType,
                _equipment,
                objNull,
                _interpolate,
                _attachToLogic
            ] call BIS_fnc_ambientAnim;
        };
    };

    private _onAgentsCreated = getText(_classConfig >> "onAgentsCreated");
    if (_onAgentsCreated isNotEqualTo "") then {
        _onAgentsCreated = compile _onAgentsCreated;
        [
            _onAgentsCreated,
            [_agents]
        ] call CBA_fnc_directCall;
    };

    _base_agentsList append _agents;
};


_baseMap