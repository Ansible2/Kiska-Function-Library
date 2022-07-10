/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_infantry

Description:
	Spawns a configed KISKA bases' infantry.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - a hashmap containing data abou the base:
        "unit list": <ARRAY of OBJECTs> - All spawned units (includes turret units)
        "group list": <ARRAY of GROUPs> - All spawned groups (does NOT include turret units)
        "turret gunners": <ARRAY of OBJECTs> - All turret units
        "infantry units": <ARRAY of OBJECTs> - All infantry spawned units
        "infantry groups": <ARRAY of GROUPs> - All infantry spawned groups
        "patrol units": <ARRAY of OBJECTs> - All patrol spawned units
        "patrol groups": <ARRAY of GROUPs> - All patrol spawned groups
        "land vehicles": <ARRAY of OBJECTs> - All land spawned vehicles
        "land vehicle groups": <ARRAY of GROUPs> - All land vehicle crew groups

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

/* ----------------------------------------------------------------------------

    Helper functions

---------------------------------------------------------------------------- */
private _baseUnitClasses = getArray(_baseConfig >> "infantryClasses");
private _fn_getUnitClasses = {
    params ["_configClass"];

    private _unitClasses = getArray(_configClass >> "infantryClasses");
    if (_unitClasses isEqualTo []) then {
        if (_turretClassUnitClasses isNotEqualTo []) then {
            _unitClasses = _turretClassUnitClasses;
        } else {
            _unitClasses = _baseUnitClasses;
        };
    };


    _unitClasses
};

private _baseSide = (getNumber(_baseConfig >> "side")) call BIS_fnc_sideType;
private _fn_getSide = {
    params ["_configClass"];

    private _side = _baseSide;
    private _sideProperty = _configClass >> "side";
    if !(isNull _sideProperty) then {
        _side = (getNumber(_sideProperty)) call BIS_fnc_sideType;
    };


    _side
};



/* ----------------------------------------------------------------------------

    Create Infantry

---------------------------------------------------------------------------- */
private _infantryConfig = _baseConfig >> "infantry";
private _infantryClasses = configProperties [_infantryConfig,"isClass _x"];
private _infantryClassUnitClasses = getArray(_infantryConfig >> "infantryClasses");

_infantryClasses apply {
    private _classConfig = _x;
    private _spawnPositions = [_classConfig >> "positions"] call BIS_fnc_getCfgData;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = [_spawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };

    if (_spawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };


    private _unitClasses = [_x] call _fn_getUnitClasses;
    private _side = [_x] call _fn_getSide;

    private _numberOfUnits = getNumber(_classConfig >> "numberOfUnits");
    private _unitsPerGroup = getNumber(_classConfig >> "unitsPerGroup");
    if (_unitsPerGroup < 1) then {
        _unitsPerGroup = _numberOfUnits;
    };

    private _units = [
        _numberOfUnits,
        _unitsPerGroup,
        _unitClasses,
        _spawnPositions,
        [_classConfig >> "canPath"] call BIS_fnc_getCfgDataBool,
        [_classConfig >> "dynamicSim"] call BIS_fnc_getCfgDataBool,
        _side
    ] call KISKA_fnc_spawn;


    private _animate = [_classConfig >> "ambientAnim"] call BIS_fnc_getCfgDataBool;
    if (_animate) then {
        _units apply {
            [
                _x,
                "STAND",
                "ASIS"
            ] call BIS_fnc_ambientAnimCombat;
        };
    };

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
        _x setVariable ["KISKA_bases_baseId",_baseName];
    };


    /* -------------------------------------------
        Reinforce Class
    ------------------------------------------- */
    private _reinforceClass = _x >> "reinforce";
    if (isNull _reinforceClass) then {
        continue;
    };

    private _reinforceId = [_reinforceClass >> "id"] call BIS_fnc_getCfgData;
    private _canCallIds = getArray(_reinforceClass >> "canCall");
    private _reinforcePriority = getNumber(_reinforceClass >> "priority");
    private _onEnteredCombat = getText(_reinforceClass >> "onEnteredCombat");
    _groups apply {
        [
            _x,
            _reinforceId,
            _canCallIds,
            _reinforcePriority,
            _onEnteredCombat
        ] call KISKA_fnc_bases_setupReactivity;
    };
};


_baseMap
