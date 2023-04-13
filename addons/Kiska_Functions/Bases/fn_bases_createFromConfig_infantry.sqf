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
    [[_baseConfig, " is a null config path"],true] call KISKA_fnc_log;
    []
};


private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";
private _base_infantryUnits = _baseMap get "infantry units";
private _base_infantryGroups = _baseMap get "infantry groups";

private _infantryConfig = _baseConfig >> "infantry";
private _infantryClasses = configProperties [_infantryConfig,"isClass _x"];



/* ----------------------------------------------------------------------------

    Create Infantry

---------------------------------------------------------------------------- */
_infantryClasses apply {
    private _classConfig = _x;
    private _spawnPositions = (_classConfig >> "positions") call BIS_fnc_getCfgData;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = [_spawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };

    if (_spawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };

    private _unitClasses = [[_x,_baseConfig,_infantryConfig]] call KISKA_fnc_bases_getInfantryClasses;
    private _side = [[_x,_baseConfig,_infantryConfig]] call KISKA_fnc_bases_getSide;

    private _numberOfUnits = getNumber(_classConfig >> "numberOfUnits");
    private _unitsPerGroup = getNumber(_classConfig >> "unitsPerGroup");
    if (_unitsPerGroup < 1) then {
        _unitsPerGroup = _numberOfUnits;
    };

    private _allowedStances = getArray(_classConfig >> "stances");
    if (_allowedStances isEqualTo []) then {
        _allowedStances = ["up",0.7,"middle",0.3];
    };

    private _units = [
        _numberOfUnits,
        _unitsPerGroup,
        _unitClasses,
        _spawnPositions,
        [_classConfig >> "canPath"] call BIS_fnc_getCfgDataBool,
        [_classConfig >> "dynamicSim"] call BIS_fnc_getCfgDataBool,
        _side,
        _allowedStances
    ] call KISKA_fnc_spawn;

    [_classConfig,_units] call KISKA_fnc_bases_initAmbientAnimFromClass;

    private _onUnitsCreated = getText(_classConfig >> "onUnitsCreated");
    if (_onUnitsCreated isNotEqualTo "") then {
        _onUnitsCreated = compile _onUnitsCreated;
        [
            _onUnitsCreated,
            [_units]
        ] call CBA_fnc_directCall;
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
        _x setVariable ["KISKA_bases_config",_classConfig];
    };


    if (isNull (_x >> "reinforce")) then { continue; };
    [_groups,_x] call KISKA_fnc_bases_initReinforceFromClass;
};


_baseMap
