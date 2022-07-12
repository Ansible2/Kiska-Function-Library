/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_patrols

Description:
	Spawns a configed KISKA bases' patrols.

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
        ] call KISKA_fnc_bases_createFromConfig_patrols;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_patrols";

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
    []
};


private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";
private _base_patrolUnits = _baseMap get "patrol units";
private _base_patrolGroups = _baseMap get "patrol groups";

/* ----------------------------------------------------------------------------

    Helper functions

---------------------------------------------------------------------------- */
private _patrolsConfig = _baseConfig >> "patrols";
private _patrolClasses = configProperties [_patrolsConfig,"isClass _x"];
private _patrolClassUnitClasses = getArray(_patrolsConfig >> "infantryClasses");

private _baseUnitClasses = getArray(_baseConfig >> "infantryClasses");
private _fn_getUnitClasses = {
    params ["_configClass"];

    private _unitClasses = getArray(_configClass >> "infantryClasses");
    if (_unitClasses isEqualTo []) then {
        if (_patrolClassUnitClasses isNotEqualTo []) then {
            _unitClasses = _patrolClassUnitClasses;
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

    Create Patrols

---------------------------------------------------------------------------- */
_patrolClasses apply {
    private _spawnPosition = (_x >> "spawnPosition") call BIS_fnc_getCfgData;
    if (_spawnPosition isEqualType "") then {
        _spawnPosition = missionNamespace getVariable [_spawnPosition,objNull];
    };

    private _unitClasses = [_x] call _fn_getUnitClasses;
    private _side = [_x] call _fn_getSide;


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
        private _patrolPoints = (_specificPatrolClass >> "patrolPoints") call BIS_fnc_getCfgData;
        if (_patrolPoints isEqualType "") then {
            _patrolPoints = [_patrolPoints] call KISKA_fnc_getMissionLayerObjects;
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

    /* -------------------------------------------
        Reinforce Class
    ------------------------------------------- */
    private _reinforceClass = _x >> "reinforce";
    if (isNull _reinforceClass) then {
        continue;
    };

    private _reinforceId = (_reinforceClass >> "id") call BIS_fnc_getCfgData;
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




_baseMap
