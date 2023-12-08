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
        ] call KISKA_fnc_bases_createFromConfig_infantry;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_infantry";

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
        ["_infantrySetConfig",configNull,[configNull]],
        "_default",
        ["_isBool",false,[false]],
        ["_canSelectFromSetRoot",true,[false]],
        ["_canSelectFromBaseRoot",true,[false]]
    ];

    private _infantrySetConditionalValue = [_infantrySetConfig >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
    if !(isNil "_infantrySetConditionalValue") exitWith { _infantrySetConditionalValue };

    private _infantrySetPropertyConfigPath = _infantrySetConfig >> _property;
    if !(isNull _infantrySetPropertyConfigPath) exitWith {
        [_infantrySetPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
    };

    private "_propertyValue";
    if (_canSelectFromSetRoot) then {
        private _infantrySectionConfigPath = _baseConfig >> "infantry";
        private _infantrySectionConditionalValue = [_infantrySectionConfigPath >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
        if !(isNil "_infantrySectionConditionalValue") exitWith { _infantrySectionConditionalValue };

        private _infantrySectionPropertyConfigPath = _infantrySectionConfigPath >> _property;
        if !(isNull _infantrySectionPropertyConfigPath) then {
            _propertyValue = [_infantrySectionPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
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
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";
private _base_infantryUnits = _baseMap get "infantry units";
private _base_infantryGroups = _baseMap get "infantry groups";

private _infantryConfig = _baseConfig >> "infantry";
private _infantryClasses = configProperties [_infantryConfig >> "sets","isClass _x"];



/* ----------------------------------------------------------------------------

    Create Infantry

---------------------------------------------------------------------------- */
_infantryClasses apply {
    private _infantrySetConfig = _x;

    private _spawnPositions = [
        "spawnPositions",
        _infantrySetConfig,
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


    private _unitClasses = ["unitClasses", _infantrySetConfig, []] call _fn_getPropertyValue;
    if (_unitClasses isEqualType "") then {
        _unitClasses = [[_infantrySetConfig],_unitClasses] call KISKA_fnc_callBack;
    };
    if (_unitClasses isEqualTo []) then {
        [["Found no unitClasses to use for KISKA base class: ",_infantrySetConfig], true] call KISKA_fnc_log;
        continue;
    };


    private _side = ["side", _infantrySetConfig, 0] call _fn_getPropertyValue;
    _side = _side call BIS_fnc_sideType;

    private _numberOfUnits = [
        "numberOfUnits", 
        _infantrySetConfig, 
        -1,
        false,
        true,
        false
    ] call _fn_getPropertyValue;
    if (_numberOfUnits isEqualType "") then {
        _numberOfUnits = [[_spawnPositions],_numberOfUnits,false] call KISKA_fnc_callBack;
    };

    private _unitsPerGroup = [
        "unitsPerGroup", 
        _infantrySetConfig, 
        -1,
        false,
        true,
        false
    ] call _fn_getPropertyValue;
    if (_unitsPerGroup isEqualType "") then {
        _unitsPerGroup = [[_infantrySetConfig,_numberOfUnits],_unitsPerGroup,false] call KISKA_fnc_callBack;
    };

    private _allowedStances = [
        "stances", 
        _infantrySetConfig, 
        ["up",0.7,"middle",0.3],
        false,
        true,
        false
    ] call _fn_getPropertyValue;

    private _canPath = [
        "canPath", 
        _infantrySetConfig, 
        true,
        true,
        true,
        false
    ] call _fn_getPropertyValue;

    private _enableDynamicSim = ["dynamicSim", _infantrySetConfig, true, true] call _fn_getPropertyValue;

    private _units = [
        _numberOfUnits,
        _unitsPerGroup,
        _unitClasses,
        _spawnPositions,
        _canPath,
        _enableDynamicSim,
        _side,
        _allowedStances
    ] call KISKA_fnc_spawn;

    if (_units isEqualTo []) then {
        [
            [
                "Unable to create any units for config: ",
                _infantrySetConfig,
                " Check KISKA Base configuration for it."
            ],
            true
        ] call KISKA_fnc_log;
        continue;
    };


    [_infantrySetConfig,_units] call KISKA_fnc_bases_initAmbientAnimFromClass;

    private _onUnitsCreated = getText(_infantrySetConfig >> "onUnitsCreated");
    private _onUnitsCreated = [
        "onUnitsCreated", 
        _infantrySetConfig, 
        "",
        false,
        true,
        false
    ] call _fn_getPropertyValue;
    if (_onUnitsCreated isNotEqualTo "") then {
        [[_infantrySetConfig,_units],_onUnitsCreated,false] call KISKA_fnc_callBack;
    };

    _base_unitList append _units;
    _base_infantryUnits append _units;

    private _groups = [];
    _units apply {
        private _group = group _x;
        _groups pushBackUnique _group;
    };

    _base_groupList append _groups;
    _base_infantryGroups append _groups;
    _groups apply {
        _x setVariable ["KISKA_bases_config",_infantrySetConfig];
    };


    if (isNull (_x >> "reinforce")) then { continue; };
    [_groups,_x] call KISKA_fnc_bases_initReinforceFromClass;
};


_baseMap
