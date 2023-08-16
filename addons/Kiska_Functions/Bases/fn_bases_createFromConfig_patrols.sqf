/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_patrols

Description:
    Spawns a configed KISKA bases' patrols.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

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
    ["A null _baseConfig was passed",true] call KISKA_fnc_log;
    []
};


private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";
private _base_patrolUnits = _baseMap get "patrol units";
private _base_patrolGroups = _baseMap get "patrol groups";

private _patrolsConfig = _baseConfig >> "patrols";
private _patrolClasses = configProperties [_patrolsConfig,"isClass _x"];

/* ----------------------------------------------------------------------------

    Create Patrols

---------------------------------------------------------------------------- */
_patrolClasses apply {
    private _spawnPosition = (_x >> "spawnPosition") call BIS_fnc_getCfgData;
    if (_spawnPosition isEqualType "") then {
        _spawnPosition = missionNamespace getVariable [_spawnPosition,objNull];
    };

    private _unitClasses = [[_x,_baseConfig,_patrolsConfig]] call KISKA_fnc_bases_getInfantryClasses;
    private _side = [[_x,_baseConfig,_patrolsConfig]] call KISKA_fnc_bases_getSide;

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

    if (isNull (_x >> "reinforce")) then { continue; };
    [_group,_x] call KISKA_fnc_bases_initReinforceFromClass;
};




_baseMap
