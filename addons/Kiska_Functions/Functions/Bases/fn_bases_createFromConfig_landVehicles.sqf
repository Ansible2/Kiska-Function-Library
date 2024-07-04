/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_landVehicles

Description:
    Spawns a configed KISKA bases' land vehicles.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

Examples:
    (begin example)
        [
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_createFromConfig_landVehicles;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_landVehicles";

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
        ["_vehicleSetConfigPath",configNull,[configNull]],
        "_default",
        ["_isBool",false,[false]],
        ["_canSelectFromSetRoot",true,[false]],
        ["_canSelectFromBaseRoot",true,[false]]
    ];

    private _turretSetConditionalValue = [_vehicleSetConfigPath >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
    if !(isNil "_turretSetConditionalValue") exitWith { _turretSetConditionalValue };

    private _turretSetPropertyConfigPath = _vehicleSetConfigPath >> _property;
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
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";
private _base_landVehicles = _baseMap get "land vehicles";
private _base_landVehicleGroups = _baseMap get "land vehicle groups";



/* ----------------------------------------------------------------------------

    Create Vehicles

---------------------------------------------------------------------------- */
private _landVehiclesConfig = _baseConfig >> "landVehicles";
private _landVehicleConfigClasses = configProperties [_landVehiclesConfig,"isClass _x"];
_landVehicleConfigClasses apply {
    private _side = [[_x,_baseConfig,_landVehiclesConfig]] call KISKA_fnc_bases_getSide;

    private _spawnPosition = (_x >> "position") call BIS_fnc_getCfgData;
    private _spawnDirection = -1;
    if (_spawnPosition isEqualType "") then {
        _spawnPosition = missionNamespace getVariable [_spawnPosition,objNull];
    };

    if (_spawnPosition isEqualType []) then {
        _spawnDirection = 0;
        if (count _spawnPosition > 3) then {
            _spawnDirection = _spawnPosition deleteAt 3;
        };
    };

    private _vehicleClass = (_x >> "vehicleClass") call BIS_fnc_getCfgData;
    if (_vehicleClass isEqualType []) then {
        _vehicleClass = selectRandom _vehicleClass;
    };

    private _vehicleInfo = [
        _spawnPosition,
        _spawnDirection,
        _vehicleClass,
        _side,
        true,
        getArray(_x >> "crew"),
        true
    ] call KISKA_fnc_spawnVehicle;
    _vehicleInfo params ["_vehicle","_units","_group"];

    _base_unitList append _units;
    _base_groupList pushBack _group;
    _base_landVehicles pushBack _vehicle;
    _base_landVehicleGroups pushBack _group;


    if ([_x >> "dynamicSim"] call BIS_fnc_getCfgDataBool) then {
        [_vehicle, true] remoteExec ["enableDynamicSimulation", 2];
        [_group, true] remoteExec ["enableDynamicSimulation", 2];
    };

    if !([_x >> "canPath"] call BIS_fnc_getCfgDataBool) then {
        (driver _vehicle) disableAI "PATH";
    };

    private _onVehicleCreated = getText(_x >> "onVehicleCreated");
    if (_onVehicleCreated isNotEqualTo "") then {
        [
            compile _onVehicleCreated,
            _vehicleInfo
        ] call CBA_fnc_directCall;
    };


    if (isNull (_x >> "reinforce")) then {continue;};
    [_x, _group] call KISKA_fnc_bases_initReinforceFromClass;
};


_baseMap
