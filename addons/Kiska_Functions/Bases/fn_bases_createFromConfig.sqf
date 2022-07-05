/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig

Description:
	Spawns a configed KISKA base.

Parameters:
    0: _baseConfig <STRING or CONFIG> - The config path of the base config or if
        in missionConfigFile >> "KISKA_bases" config, its class

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
		private _baseMap = ["SomeBaseConfig"] call KISKA_fnc_bases_createFromConfig;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig";


#define GET_MISSION_LAYER_OBJECTS(LAYER) (getMissionLayerEntities LAYER) select 0
#define INFANTRY_CLASSES_PROPERTY "infantryClasses"

#define DEFINE_UNIT_CLASSES(classSpecificArray) \
    private _unitClasses = getArray(_x >> INFANTRY_CLASSES_PROPERTY); \
    if (_unitClasses isEqualTo []) then { \
        if (classSpecificArray isNotEqualTo []) then { \
            _unitClasses = classSpecificArray; \
        } else { \
            _unitClasses = _baseUnitClasses; \
        }; \
    };

#define DEFINE_SIDE \
    private _side = _baseSide; \
    private _sideProperty = _x >> "side"; \
    if !(isNull _sideProperty) then { \
        _side = (getNumber(_sideProperty)) call BIS_fnc_sideType; \
    };

#define DEFAULT_PATROL_BEHAVIOUR "SAFE"
#define DEFAULT_PATROL_SPEED "LIMITED"
#define DEFAULT_PATROL_COMBATMODE "RED"
#define DEFAULT_PATROL_FORMATION "STAG COLUMN"
#define DEFAULT_SIMPLE_OFFSET [0,0,0.1]

#define SIMPLE_DATA_INDEX_TYPE 0
#define SIMPLE_DATA_INDEX_OFFSET 1
#define SIMPLE_DATA_INDEX_VECTORUP 2
#define SIMPLE_DATA_INDEX_VECTORDIR 3
#define SIMPLE_DATA_INDEX_ANIMATIONS 4
#define SIMPLE_DATA_INDEX_SELECTIONS 5
#define SIMPLE_DATA_INDEX_CREATED_EVENT 6
#define SIMPLE_DATA_INDEX_FOLLOW_TERRAIN 7
#define SIMPLE_DATA_INDEX_SUPERSIMPLE 8



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


private _baseUnitClasses = getArray(_baseConfig >> INFANTRY_CLASSES_PROPERTY);
private _baseSide = (getNumber(_baseConfig >> "side")) call BIS_fnc_sideType;


/* ----------------------------------------------------------------------------
    Setup return data and globals
---------------------------------------------------------------------------- */
private _baseName = configName _baseConfig;

private _base_unitList = [];
private _base_groupList = [];
private _base_turretGunners = [];
private _base_infantryUnits = [];
private _base_infantryGroups = [];
private _base_patrolUnits = [];
private _base_patrolGroups = [];
private _base_landVehicleGroups = [];
private _base_landVehicles = [];
private _base_reinforceMap = createHashMap;
private _baseData = createHashMapFromArray [
    ["unit list",_base_unitList],
    ["group list",_base_groupList],
    ["turret gunners",_base_turretGunners],
    ["infantry units",_base_infantryUnits],
    ["infantry groups",_base_infantryGroups],
    ["patrol units",_base_patrolUnits],
    ["patrol groups",_base_patrolGroups],
    ["land vehicles",_base_landVehicles],
    ["land vehicle groups",_base_landVehicleGroups]
];


if (isNil "KISKA_bases_map") then {
    missionNamespace setVariable ["KISKA_bases_map",createHashMap];
};

KISKA_bases_map set [_baseName,_baseData];



/* ----------------------------------------------------------------------------
    Turrets
---------------------------------------------------------------------------- */
private _turretConfig = _baseConfig >> "turrets";
private _turretClasses = configProperties [_turretConfig,"isClass _x"];
private _turretClassUnitClasses = getArray(_turretConfig >> INFANTRY_CLASSES_PROPERTY);
_turretClasses apply {
    private _turrets = [_x >> "turrets"] call BIS_fnc_getCfgData;
    if (_turrets isEqualType "") then {
        _turrets = GET_MISSION_LAYER_OBJECTS(_turrets);

    } else {

        _turrets = _turrets apply {
            private _turret = missionNamespace getVariable [_x,objNull];
            if (isNull _turret) then {
                continue;
            };

            _turret
        };
    };

    if (_turrets isEqualTo []) then {
        continue;
    };


    DEFINE_UNIT_CLASSES(_turretClassUnitClasses)
    DEFINE_SIDE

    private _enableDynamicSim = [_x >> "dynamicSim"] call BIS_fnc_getCfgDataBool;
    private _excludeFromHeadlessTransfer = [_x >> "excludeHCTransfer"] call BIS_fnc_getCfgDataBool;

    private _onUnitCreated = compile getText(_x >> "onUnitCreated");
    private _onUnitMovedInGunner = compile getText(_x >> "onUnitMovedInGunner");

    private ["_group","_unit","_unitClass"];
    private _weightedArray = _unitClasses isEqualTypeParams ["",1];
    private _reinforceClass = _x >> "reinforce";
    _turrets apply {
        _group = createGroup _side;

        _unitClass = [
            selectRandom _unitClasses,
            selectRandomWeighted _unitClasses
        ] select _weightedArray;

        _unit = _group createUnit [_unitClass,[0,0,0],[],0,"NONE"];

        [_group,_excludeFromHeadlessTransfer] call KISKA_fnc_ACEX_setHCTransfer;


        if (_onUnitCreated isNotEqualto {}) then {
            [
                _onUnitCreated,
                [_unit]
            ] call CBA_fnc_directCall;
        };


        if (_enableDynamicSim) then {
            _group enableDynamicSimulation true;
        };
        _unit moveInGunner _x;


        if (_onUnitMovedInGunner isNotEqualto {}) then {
            [
                _onUnitMovedInGunner,
                [_unit,_x]
            ] call CBA_fnc_directCall;
        };

        _base_turretGunners pushBack _unit;
        _base_unitList pushBack _unit;
        _base_groupList pushBack _group;

        if (isNull _reinforceClass) then {
            continue;
        };
        private _reinforceId = [_reinforceClass >> "id"] call BIS_fnc_getCfgData;
        private _canCallIds = getArray(_reinforceClass >> "canCall");
        private _reinforcePriority = getNumber(_reinforceClass >> "priority");
        private _onEnteredCombat = getText(_reinforceClass >> "onEnteredCombat");
        [
            _group,
            _reinforceId,
            _canCallIds,
            _reinforcePriority,
            _onEnteredCombat
        ] call KISKA_fnc_bases_setupReactivity;
    };

};



/* ----------------------------------------------------------------------------
    Infantry
---------------------------------------------------------------------------- */
private _infantryConfig = _baseConfig >> "infantry";
private _infantryClasses = configProperties [_infantryConfig,"isClass _x"];
private _infantryClassUnitClasses = getArray(_infantryConfig >> INFANTRY_CLASSES_PROPERTY);
_infantryClasses apply {
    private _classConfig = _x;
    private _spawnPositions = [_classConfig >> "positions"] call BIS_fnc_getCfgData;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = GET_MISSION_LAYER_OBJECTS(_spawnPositions);
    };

    if (_spawnPositions isEqualTo []) then {
        continue;
    };


    DEFINE_UNIT_CLASSES(_infantryClassUnitClasses)
    DEFINE_SIDE

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


/* ----------------------------------------------------------------------------
    Patrols
---------------------------------------------------------------------------- */
private _patrolsConfig = _baseConfig >> "patrols";
private _patrolClasses = configProperties [_patrolsConfig,"isClass _x"];
private _patrolClassUnitClasses = getArray(_patrolsConfig >> INFANTRY_CLASSES_PROPERTY);
_patrolClasses apply {
    private _spawnPosition = [_x >> "spawnPosition"] call BIS_fnc_getCfgData;
    if (_spawnPosition isEqualType "") then {
        _spawnPosition = missionNamespace getVariable [_spawnPosition,objNull];
    };

    DEFINE_UNIT_CLASSES(_patrolClassUnitClasses) // _unitClasses
    DEFINE_SIDE // _side


    private _group = [
        getNumber(_x >> "numberOfUnits"),
        _unitClasses,
        _side,
        _spawnPosition,
        [_x >> "dynamicSim"] call BIS_fnc_getCfgDataBool
    ] call KISKA_fnc_spawnGroup;


    // patrol point details
    private _behaviour = getText(_x >> "behaviour");
    if (_behaviour isEqualTo "") then {
        _behaviour = DEFAULT_PATROL_BEHAVIOUR;
    };
    private _speed = getText(_x >> "speed");
    if (_speed isEqualTo "") then {
        _speed = DEFAULT_PATROL_SPEED;
    };
    private _combatMode = getText(_x >> "combatMode");
    if (_combatMode isEqualTo "") then {
        _combatMode = DEFAULT_PATROL_COMBATMODE;
    };
    private _formation = getText(_x >> "formation");
    if (_formation isEqualTo "") then {
        _formation = DEFAULT_PATROL_FORMATION;
    };



    private _specificPatrolClass = _x >> "SpecificPatrol";
    if (isClass _specificPatrolClass) then {
        private _patrolPoints = [_specificPatrolClass >> "patrolPoints"] call BIS_fnc_getCfgData;
        if (_patrolPoints isEqualType "") then {
            _patrolPoints = GET_MISSION_LAYER_OBJECTS(_patrolPoints);
        };

        if (_patrolPoints isEqualTo []) then {
            [["Retrieved empty patrol points array for config class: ", _x >> "SpecificPatrol"],true] call KISKA_fnc_log;
            continue;
        };

        [
            _group,
            _patrolPoints,
            getNumber(_specificPatrolClass >> "numberOfPoints"),
            [_specificPatrolClass >> "random"] call BIS_fnc_getCfgDataBool,
            _behaviour,
            _speed,
            _combatMode,
            _formation
        ] call KISKA_fnc_patrolSpecific;

    } else {
        private _randomPatrolClass = _x >> "RandomPatrol";

        // get params
        private _patrolCenter = [_randomPatrolClass >> "center"] call BIS_fnc_getCfgDataArray;
        if (_patrolCenter isEqualTo []) then {
            _patrolCenter = _spawnPosition;
        };
        private _waypointType = getText(_randomPatrolClass >> "waypointType");
        if (_waypointType isEqualTo "") then {
            _waypointType = "MOVE";
        };
        private _radius = getNumber(_randomPatrolClass >> "radius");
        if (_radius isEqualTo 0) then {
            _radius = 500;
        };


        [
            _group,
            _patrolCenter,
            _radius,
            getNumber(_randomPatrolClass >> "numberOfPoints"),
            _waypointType,
            _behaviour,
            _combatMode,
            _speed,
            _formation
        ] call CBA_fnc_taskPatrol;
    };

    private _onGroupCreated = getText(_x >> "onGroupCreated");
    if (_onGroupCreated isNotEqualTo "") then {
        [
            compile _onGroupCreated,
            [_group]
        ] call CBA_fnc_directCall;
    };

    _base_groupList pushBack _group;
    _base_patrolGroups pushBack _group;

    private _units = units _group;
    _base_unitList append _units;
    _base_patrolUnits append _units;

    private _reinforceClass = _x >> "reinforce";
    if (isNull _reinforceClass) then {
        continue;
    };

    private _reinforceId = [_reinforceClass >> "id"] call BIS_fnc_getCfgData;
    private _canCallIds = getArray(_reinforceClass >> "canCall");
    private _reinforcePriority = getNumber(_reinforceClass >> "priority");
    private _onEnteredCombat = getText(_reinforceClass >> "onEnteredCombat");
    [
        _group,
        _reinforceId,
        _canCallIds,
        _reinforcePriority,
        _onEnteredCombat
    ] call KISKA_fnc_bases_setupReactivity;
};


/* ----------------------------------------------------------------------------
    Land Vehicles
---------------------------------------------------------------------------- */
private _landVehiclesConfig = _baseConfig >> "landVehicles";
private _landVehicleConfigClasses = configProperties [_landVehiclesConfig,"isClass _x"];
_landVehicleConfigClasses apply {
    DEFINE_SIDE // _side

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
        [_vehicle] remoteExec ["enableDynamicSimulation",0,true];
        [_group] remoteExec ["enableDynamicSimulation",0,true];
    };

    if !([_x >> "dynamicSim"] call BIS_fnc_getCfgDataBool) then {
        (driver _vehicle) disableAI "PATH";
    };

    private _onVehicleCreated = getText(_x >> "onVehicleCreated");
    if (_onVehicleCreated isNotEqualTo "") then {
        [
            compile _onVehicleCreated,
            _vehicleInfo
        ] call CBA_fnc_directCall;
    };


    private _reinforceClass = _x >> "reinforce";
    if (isNull _reinforceClass) then {
        continue;
    };

    private _reinforceId = [_reinforceClass >> "id"] call BIS_fnc_getCfgData;
    private _canCallIds = getArray(_reinforceClass >> "canCall");
    private _reinforcePriority = getNumber(_reinforceClass >> "priority");
    private _onEnteredCombat = getText(_reinforceClass >> "onEnteredCombat");
    [
        _group,
        _reinforceId,
        _canCallIds,
        _reinforcePriority,
        _onEnteredCombat
    ] call KISKA_fnc_bases_setupReactivity;
};



/* ----------------------------------------------------------------------------
    Simple Objects
---------------------------------------------------------------------------- */
private _simplesConfig = _baseConfig >> "Simples";
private _simplesConfigClasses = configProperties [_simplesConfig,"isClass _x"];

private _configDataHashMap = createHashMap;
private _fn_getSimpleClassData = {
    params ["_config"];

    private "_dataArray";
    if (_config in _configDataHashMap) then {
        _dataArray = _configDataHashMap get _config;

    } else {
        _dataArray = [];

        _dataArray pushBack (getText(_config >> "type"));

        private _offsetConfig = _config >> "offset";
        if (isArray _offsetConfig) then {
            _dataArray pushBack (getArray _offsetConfig);
        } else {
            _dataArray pushBack [0,0,0.1];
        };

        _dataArray pushBack (getArray(_config >> "vectorUp"));
        _dataArray pushBack (getArray(_config >> "vectorDir"));
        _dataArray pushBack (getArray(_config >> "animations"));
        _dataArray pushBack (getArray(_config >> "selections"));
        _dataArray pushBack (compile (getText(_config >> "onObjectCreated")));

        private _followTerrainConfig = _config >> "followTerrain";
        if (isNumber _followTerrainConfig) then {
            _dataArray pushBack ([_followTerrainConfig] call BIS_fnc_getCfgDataBool);

        } else {
            _dataArray pushBack true;

        };

        private _superSimpleConfig = _config >> "superSimple";
        if (isNumber _superSimpleConfig) then {
            _dataArray pushBack ([_superSimpleConfig] call BIS_fnc_getCfgDataBool);

        } else {
            _dataArray pushBack true;

        };

        _configDataHashMap set [_config,_dataArray];
    };


    _dataArray
};


private ["_topConfig","_typeConfigs","_objectDirection","_offset","_vectorUp","_vectorDir","_animations","_selections","_onObjectCreated"];
_simplesConfigClasses apply {
    _topConfig = _x;
    _typeConfigs = configProperties [_topConfig,"isClass _x"];

    private _positions = [_topConfig >> "positions"] call BIS_fnc_getCfgData;
    if (_positions isEqualType "") then {
        private "_position";
        _positions = (GET_MISSION_LAYER_OBJECTS(_positions)) apply {
            _position = getPosASL _x;
            _position pushBack (getDir _x);

            _position
        };
    };


    _positions apply {
        if (count _x > 3) then {
            _objectDirection = _x deleteAt 3;
        } else {
            _objectDirection = 0;
        };

        private _objectClass = selectRandom _typeConfigs;
        private _objectData = [_objectClass] call _fn_getSimpleClassData;
        private _object = [
            _objectData select SIMPLE_DATA_INDEX_TYPE,
            _x,
            _objectDirection,
            _objectData select SIMPLE_DATA_INDEX_FOLLOW_TERRAIN,
            _objectData select SIMPLE_DATA_INDEX_SUPERSIMPLE
        ] call BIS_fnc_createSimpleObject;


        _offset = _objectData select SIMPLE_DATA_INDEX_OFFSET;
        if (_offset isNotEqualTo []) then {
            _object setPosASL (_x vectorAdd _offset);
        };

        _vectorDir = _objectData select SIMPLE_DATA_INDEX_VECTORDIR;
        if (_vectorDir isNotEqualTo []) then {
            _object setVectorDir _vectorDir;
        };

        _vectorUp = _objectData select SIMPLE_DATA_INDEX_VECTORUP;
        if (_vectorUp isNotEqualTo []) then {
            _object setVectorUp _vectorUp;
        };

        (_objectData select SIMPLE_DATA_INDEX_ANIMATIONS) apply {
            _object animate [_x select 0, _x select 1, true];
        };
        (_objectData select SIMPLE_DATA_INDEX_SELECTIONS) apply {
            _object hideSelection [_x select 0, (_x select 1) > 0];
        };

        _onObjectCreated = _objectData select SIMPLE_DATA_INDEX_CREATED_EVENT;
        if (_onObjectCreated isNotEqualTo {}) then {
            [
                _onObjectCreated,
                [_object]
            ] call CBA_fnc_directCall;
        };
    };

};


_baseData
