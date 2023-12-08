/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_turrets

Description:
    Spawns a configed KISKA bases' turrets.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

Examples:
    (begin example)
        [
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_createFromConfig_turrets;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_turrets";

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
        ["_turretSetConfigPath",configNull,[configNull]],
        "_default",
        ["_isBool",false,[false]],
        ["_canSelectFromSetRoot",true,[false]],
        ["_canSelectFromBaseRoot",true,[false]]
    ];

    private _turretSetConditionalValue = [_turretSetConfigPath >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
    if !(isNil "_turretSetConditionalValue") exitWith { _turretSetConditionalValue };

    private _turretSetPropertyConfigPath = _turretSetConfigPath >> _property;
    if !(isNull _turretSetPropertyConfigPath) exitWith {
        [_turretSetPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
    };

    private "_propertyValue";
    if (_canSelectFromSetRoot) then {
        private _turretSectionConfigPath = _baseConfig >> "turrets";
        private _turretSectionConditionalValue = [_turretSectionConfigPath >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
        if !(isNil "_turretSectionConditionalValue") exitWith { _turretSectionConditionalValue };

        private _turretSectionPropertyConfigPath = _turretSectionConfigPath >> _property;
        if !(isNull _turretSectionPropertyConfigPath) then {
            _propertyValue = [_turretSectionPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
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
private _base_turretGunners = _baseMap get "turret gunners";
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";

private _baseTurretsConfig = _baseConfig >> "turrets";
private _turretClasses = configProperties [_baseTurretsConfig >> "sets","isClass _x"];

/* ----------------------------------------------------------------------------

    Create Turrets

---------------------------------------------------------------------------- */
_turretClasses apply {
    private _turretConfig = _x;

    private _turretSpawnPositions = [
        "spawnPositions",
        _turretConfig,
        [],
        false,
        false,
        false
    ] call _fn_getPropertyValue;

    if (_turretSpawnPositions isEqualType "") then {
        _turretSpawnPositions = [_turretSpawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };
    if (_turretSpawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };


    private _turretClassNames = ["turretClassNames", _turretConfig,[]] call _fn_getPropertyValue;
    if (_turretClassNames isEqualType "") then {
        _turretClassNames = [[_turretConfig],_turretClassNames,false] call KISKA_fnc_callBack;
    };
    if (_turretClassNames isEqualTo []) then {
        [["Could not find classNames for turrets in KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };


    private _numberOfTurrets = ["numberOfTurrets", _turretConfig, -1] call _fn_getPropertyValue;
    private _totalNumberOfSpawns = count _turretSpawnPositions;
    if (_numberOfTurrets isEqualType "") then {
        _numberOfTurrets = [[_turretConfig,_turretSpawnPositions,_totalNumberOfSpawns],_numberOfTurrets,false] call KISKA_fnc_callBack;
    };
    if (_numberOfTurrets < 0) then {
        _numberOfTurrets = _totalNumberOfSpawns
    };


    private _unitClasses = ["unitClasses", _turretConfig, []] call _fn_getPropertyValue;
    if (_unitClasses isEqualType "") then {
        _unitClasses = [[_turretConfig],_unitClasses] call KISKA_fnc_callBack;
    };
    if (_unitClasses isEqualTo []) then {
        [["Found no unitClasses to use for KISKA base class: ",_turretConfig], true] call KISKA_fnc_log;
        continue;
    };


    private _turrets = [];
    for "_i" from 1 to _numberOfTurrets do {
        private _spawnPosition = [_turretSpawnPositions] call KISKA_fnc_deleteRandomIndex;
        private _class = [_turretClassNames,""] call KISKA_fnc_selectRandom;
        
        private ["_direction","_positionToSet"];
        if (_spawnPosition isEqualType objNull) then {
            _direction = getDir _spawnPosition;
            _positionToSet = getPosASL _spawnPosition;

        } else {
            private _isPostionWithDirection = (count _spawnPosition) > 3;
            if (_isPostionWithDirection) then {
                _direction = _spawnPosition deleteAt 3;
            } else {
                _direction = 0;
            };
            _positionToSet = ATLToASL _spawnPosition;

        };

        _turret = createVehicle [_class, _spawnPosition, [], 0, "NONE"];
        _turrets pushBack _turret;
        _turret setPosASL _positionToSet;
        _turret setDir _direction;
    };

    if (_turrets isEqualTo []) then {
        [["Created no turrets for KISKA base class: ",_turretConfig], true] call KISKA_fnc_log;
        continue;
    };

    private _side = ["side", _turretConfig, 0] call _fn_getPropertyValue;
    _side = _side call BIS_fnc_sideType;

    private _enableDynamicSim = ["dynamicSim", _turretConfig, true, true] call _fn_getPropertyValue;
    private _onGunnerCreated = compile (["onGunnerCreated", _turretConfig, ""] call _fn_getPropertyValue);
    private _onUnitMovedInGunner = compile (["onUnitMovedInGunner", _turretConfig, ""] call _fn_getPropertyValue);

    private _reinforceClass = _turretConfig >> "reinforce";
    _turrets apply {
        private _group = createGroup _side;
        private _unitClass = [_unitClasses,""] call KISKA_fnc_selectRandom;
        private _unit = _group createUnit [_unitClass,[0,0,0],[],0,"NONE"];

        private _eventParams = [_turretConfig,_unit,_x];
        if (_onGunnerCreated isNotEqualto {}) then {
            [
                _onGunnerCreated,
                _eventParams
            ] call CBA_fnc_directCall;
        };


        if (_enableDynamicSim) then {
            [_group, true] remoteExec ["enableDynamicSimulation", 2];
        };
        _unit moveInGunner _x;


        if (_onUnitMovedInGunner isNotEqualto {}) then {
            [
                _onUnitMovedInGunner,
                _eventParams
            ] call CBA_fnc_directCall;
        };

        _base_turretGunners pushBack _unit;
        _base_unitList pushBack _unit;
        _base_groupList pushBack _group;

        if (isNull _reinforceClass) then { continue; };
        [_group,_turretConfig] call KISKA_fnc_bases_initReinforceFromClass;
    };

};


_baseMap
