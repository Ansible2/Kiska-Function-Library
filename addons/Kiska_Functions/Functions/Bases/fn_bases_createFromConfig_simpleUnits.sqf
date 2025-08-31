/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_simpleUnits

Description:
    Spawns a configed KISKA bases' simple units. These are units created with
     the `createVehicle` command.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config or the string
        className of a config located in `missionConfigFile >> "KISKA_bases".

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

Examples:
    (begin example)
        [
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_createFromConfig_simpleUnits;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_simpleUnits";

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

private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_simpleUnitsList = _baseMap get "simple units";

private _simpleUnitsConfig = _baseConfig >> "simpleUnits";
private _simpleUnitClasses = configProperties [_simpleUnitsConfig >> "sets","isClass _x"];


/* ----------------------------------------------------------------------------

    Create Units

---------------------------------------------------------------------------- */
_simpleUnitClasses apply {
    private _simpleUnitsSetConfig = _x;

    private _spawnPositions = [
        "spawnPositions",
        _simpleUnitsSetConfig,
        [],
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = [_spawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };
    if (_spawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };
    _spawnPositions = [_spawnPositions] call CBA_fnc_shuffle;

    private _numberOfUnits = [
        "numberOfUnits", 
        _simpleUnitsSetConfig, 
        -1,
        false,
        true,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    if (_numberOfUnits isEqualType "") then {
        _numberOfUnits = [[_simpleUnitsSetConfig,_spawnPositions],_numberOfUnits,false] call KISKA_fnc_callBack;
    };

    private _numberOfSpawns = count _spawnPositions;
    if ((_numberOfSpawns < _numberOfUnits) OR (_numberOfUnits isEqualTo -1)) then {
        _numberOfUnits = _numberOfSpawns;
    };


    private _unitClasses = ["unitClasses", _simpleUnitsSetConfig, []] call KISKA_fnc_bases_getPropertyValue;
    if (_unitClasses isEqualType "") then {
        _unitClasses = [[_simpleUnitsSetConfig],_unitClasses] call KISKA_fnc_callBack;
    };
    if (_unitClasses isEqualTo []) then {
        [["Found no unitClasses to use for KISKA base class: ",_simpleUnitsSetConfig], true] call KISKA_fnc_log;
        continue;
    };

    
    private _side = ["side", _simpleUnitsSetConfig, 0] call KISKA_fnc_bases_getPropertyValue;
    _side = _side call BIS_fnc_sideType;

    private _enableDynamicSim = ["dynamicSim", _simpleUnitsSetConfig, true, true] call KISKA_fnc_bases_getPropertyValue;

    private _simpleUnits = [];
    for "_i" from 0 to (_numberOfUnits - 1) do {
        private _spawnPosition = _spawnPositions select _i;
        private _direction = 0;
        if (_spawnPosition isEqualType objNull) then {
            _direction = getDir _spawnPosition;
        };
        if ((_spawnPosition isEqualType []) AND {(count _spawnPosition) > 3}) then {
            _direction = _spawnPosition deleteAt 3;
        };

        private _simpleUnit = createVehicle [
            [_unitClasses,""] call KISKA_fnc_selectRandom,
            _spawnPosition,
            [],
            0,
            "CAN_COLLIDE"
        ];

        _simpleUnit enableDynamicSimulation _enableDynamicSim;
        _simpleUnit setDir _direction;
        _simpleUnits pushBack _simpleUnit;
    };

    [_simpleUnitsSetConfig,_simpleUnits] call KISKA_fnc_bases_initAmbientAnimFromClass;

    private _randomGearConfig = [
        "KISKA_randomGear",
        _simpleUnitsSetConfig,
        true,
        false
    ] call KISKA_fnc_bases_getClassConfig;
    if (isClass _randomGearConfig) then {
        [_simpleUnits,_randomGearConfig] call KISKA_fnc_randomGearFromConfig;
    };

    private _onUnitsCreated = [
        "onUnitsCreated", 
        _simpleUnitsSetConfig, 
        "",
        false,
        true,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    if (_onUnitsCreated isNotEqualTo "") then {
        [[_simpleUnitsSetConfig,_simpleUnits],_onUnitsCreated,false] call KISKA_fnc_callBack;
    };

    _base_simpleUnitsList append _simpleUnits;
};


_baseMap
