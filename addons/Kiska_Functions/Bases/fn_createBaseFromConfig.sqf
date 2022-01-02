/* ----------------------------------------------------------------------------
Function: KISKA_fnc_createBaseFromConfig

Description:
	Spawns a configed KISKA base.

Parameters:
    0: _baseConfig <STRING or CONFIG> - The config path of the base config or if
        in missionConfigFile >> "KISKA_bases" config, its class

Returns:
	<> -

Examples:
    (begin example)
		["SomeBaseConfig"] call KISKA_fnc_createBaseFromConfig;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_createBaseFromConfig";


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

};


private _baseUnitClasses = getArray(_baseConfig >> INFANTRY_CLASSES_PROPERTY);
private _baseSide = (getNumber(_baseConfig >> "side")) call BIS_fnc_sideType;

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
            if !(isNull _turret) then {
                continueWith _turret;

            } else {
                continue;

            };

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

    private ["_group","_unit"];
    _turrets apply {
        _group = createGroup _side;
        _unit = _group createUnit [selectRandom _unitClasses,[0,0,0],[],0,"NONE"];
        [_group,_excludeFromHeadlessTransfer] call KISKA_fnc_ACEX_setHCTransfer;


        if (_onUnitCreated isNotEqualto {}) then {
            [_unit] call _onUnitCreated;
        };


        if (_enableDynamicSim) then {
            _group enableDynamicSimulation true;
        };
        _unit moveInGunner _x;


        if (_onUnitMovedInGunner isNotEqualto {}) then {
            [_unit,_x] call _onUnitMovedInGunner;
        };
    };

};



/* ----------------------------------------------------------------------------
    Infantry
---------------------------------------------------------------------------- */
private _infantryConfig = _baseConfig >> "infantry";
private _infantryClasses = configProperties [_infantryConfig,"isClass _x"];
private _infantryClassUnitClasses = getArray(_infantryConfig >> INFANTRY_CLASSES_PROPERTY);
_infantryClasses apply {
    private _spawnPositions = [_x >> "positions"] call BIS_fnc_getCfgData;
    if (_spawnPositions isEqualType "") then {
        [_spawnPositions] call KISKA_fnc_log;
        _spawnPositions = GET_MISSION_LAYER_OBJECTS(_spawnPositions);
    };

    if (_spawnPositions isEqualTo []) then {
        continue;
    };


    DEFINE_UNIT_CLASSES(_infantryClassUnitClasses)
    DEFINE_SIDE


    private _units = [
        getNumber(_x >> "numberOfUnits"),
        getNumber(_x >> "unitsPerGroup"),
        _unitClasses,
        _spawnPositions,
        [_x >> "canPath"] call BIS_fnc_getCfgDataBool,
        [_x >> "dynamicSim"] call BIS_fnc_getCfgDataBool,
        _side
    ] call KISKA_fnc_spawn;


    private _onUnitCreated = getText(_x >> "onUnitCreated");
    if (_onUnitCreated isNotEqualTo "") then {
        _onUnitCreated = compile _onUnitCreated;
        _units apply {
            [_x] call _onUnitCreated;
        };
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
    DEFINE_SIDE // side


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
        [_group] call (compile _onGroupCreated);
    };
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
            [_object] call _onObjectCreated;
        };
    };

};


nil
