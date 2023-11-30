/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_turrets

Description:
    Spawns a configed KISKA bases' turrets.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

Examples:
    (begin example)
        [
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_createFromConfig_turrets;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_turrets";

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
private _base_turretGunners = _baseMap get "turret gunners";
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";

private _baseTurretsConfig = _baseConfig >> "turrets";
private _turretClasses = configProperties [_baseTurretsConfig >> "sets","isClass _x"];

/* ----------------------------------------------------------------------------

    Create Turrets

---------------------------------------------------------------------------- */
_turretClasses apply {
    private _turretConfig = _x;


    private _turretSpawnPositions = (_turretConfig >> "spawnPositions") call BIS_fnc_getCfgData;
    if (_turretSpawnPositions isEqualType "") then {
        _turretSpawnPositions = [_turretSpawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };
    if (_turretSpawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };

    private _turretClassNames = (_turretConfig >> "turretClassNames") call BIS_fnc_getCfgData;
    if (_turretClassNames isEqualType "") then {
        _turretClassNames = [[_turretConfig],_turretClassNames,false] call KISKA_fnc_callBack;
    };
    if (_turretClassNames isEqualTo []) then {
        [["Could not find classNames for turrets in KISKA bases class: ",_x],true] call KISKA_fnc_log;
        continue;
    };


    private _numberOfTurrets = (_classConfig >> "numberOfTurrets") call BIS_fnc_getCfgData;
    private _totalNumberOfSpawns = count _turretSpawnPositions;
    if (_numberOfTurrets isEqualType "") then {
        _numberOfTurrets = [[_totalNumberOfSpawns],_numberOfTurrets,false] call KISKA_fnc_callBack;
    };
    if (_numberOfTurrets < 0) then {
        _numberOfTurrets = _totalNumberOfSpawns
    };


    private _turrets = [];
    for "_i" from 1 to _numberOfTurrets do {
        private _spawnPosition = [_turretSpawnPositions] call KISKA_fnc_deleteRandomIndex;
        private _class = [_turretClassNames,""] call KISKA_fnc_selectRandom;
        
        private _isPostionWithDirection = (_spawnPosition isEqualType []) AND {(count _spawnPosition) > 3};
        if (_isPostionWithDirection) then {
            private _direction = _spawnPosition deleteAt 3;
            private _turret = createVehicle [_class, _spawnPosition, [], 0, "NONE"];
            _turret setDir _direction;
            _turrets pushBack _turret;
        } else {
            private _turret = createVehicle [_class, _spawnPosition, [], 0, "NONE"];
            _turrets pushBack _turret;
        };
    };

    if (_turrets isEqualTo []) then {
        [["Created no turrets for KISKA base class: ",_turretConfig], true] call KISKA_fnc_log;
        continue;
    };

    // TODO: implement new type strategy; needs more thought about how to share 
    // these classes for both getting gunner classes and infantry sets
    private _unitClasses = [
        [_turretConfig,_baseConfig,_baseTurretsConfig]
    ] call KISKA_fnc_bases_getInfantryClasses;

    private _side = [
        [_turretConfig,_baseConfig,_baseTurretsConfig]
    ] call KISKA_fnc_bases_getSide;

    private _enableDynamicSim = (_turretConfig >> "dynamicSim") call BIS_fnc_getCfgDataBool;
    private _onGunnerCreated = compile getText(_turretConfig >> "onGunnerCreated");
    private _onUnitMovedInGunner = compile getText(_turretConfig >> "onUnitMovedInGunner");

    private _reinforceClass = _turretConfig >> "reinforce";
    _turrets apply {
        private _group = createGroup _side;
        private _unitClass = [_unitClasses,""] call KISKA_fnc_selectRandom;
        private _unit = _group createUnit [_unitClass,[0,0,0],[],0,"NONE"];

        private _eventParams = [_turretConfig,_unit,_x];
        if (_onGunnerCreated isNotEqualto {}) then {
            [
                _onGunnerCreated,
                _eventParams
            ] call CBA_fnc_directCall;
        };


        if (_enableDynamicSim) then {
            [_group, true] remoteExec ["enableDynamicSimulation", 2];
        };
        _unit moveInGunner _x;


        if (_onUnitMovedInGunner isNotEqualto {}) then {
            [
                _onUnitMovedInGunner,
                _eventParams
            ] call CBA_fnc_directCall;
        };

        _base_turretGunners pushBack _unit;
        _base_unitList pushBack _unit;
        _base_groupList pushBack _group;

        if (isNull _reinforceClass) then { continue; };
        [_group,_turretConfig] call KISKA_fnc_bases_initReinforceFromClass;
    };

};


_baseMap
