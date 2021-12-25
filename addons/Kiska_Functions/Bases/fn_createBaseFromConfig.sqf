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
private _turretClasses = "true" configClasses (_turretConfig);
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
private _infantryClasses = "true" configClasses (_infantryConfig);
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
private _patrolClasses = "true" configClasses (_patrolsConfig);
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
private _simplesConfigClasses = "true" configClasses (_simplesConfig);
_simplesConfigClasses apply {
    private _useSuperSimple = [_x >> "superSimple"] call BIS_fnc_getCfgDataBool;
    private _followTerrain = [_x >> "followTerrain"] call BIS_fnc_getCfgDataBool;

    private _objectClasses = getArray(_x >> "objectClasses");
    private _positions = [_x >> "positions"] call BIS_fnc_getCfgData;
    private "_direction";

    if (_positions isEqualType "") then {
        GET_MISSION_LAYER_OBJECTS(_positions) apply {
            _direction = getDir _x;

            [
                selectRandom _objectClasses,
                getPosASL _x,
                _direction,
                _followTerrain,
                _useSuperSimple
            ] call BIS_fnc_createSimpleObject;
        };

    } else {
        _positions apply {
            _direction = _x deleteAt 3;

            [
                selectRandom _objectClasses,
                ATLtoASL _x,
                _direction,
                _followTerrain,
                _useSuperSimple
            ] call BIS_fnc_createSimpleObject;
        };

    };

};


nil
