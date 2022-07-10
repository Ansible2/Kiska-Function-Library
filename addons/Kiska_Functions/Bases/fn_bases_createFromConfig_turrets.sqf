/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_turrets

Description:
	Spawns a configed KISKA bases' turrets.

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
    [[_baseConfig, " is a null config path"],true] call KISKA_fnc_log;
    []
};


private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_turretGunners = _baseMap get "turret gunners";
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";

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

    Create Turrets

---------------------------------------------------------------------------- */
private _turretConfig = _baseConfig >> "turrets";
private _turretClasses = configProperties [_turretConfig,"isClass _x"];
private _turretClassUnitClasses = getArray(_turretConfig >> "infantryClasses");

_turretClasses apply {
    private _turrets = [_x >> "turrets"] call BIS_fnc_getCfgData;
    if (_turrets isEqualType "") then {
        _turrets = [_turrets] call KISKA_fnc_getMissionLayerObjects;

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
        [["Found no turrets for KISKA base class: ",_x], true] call KISKA_fnc_log;
        continue;
    };

    private _unitClasses = [_x] call _fn_getUnitClasses;
    private _side = [_x] call _fn_getSide;

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
            [_group, true] remoteExec ["enableDynamicSimulation", 2];
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

        /* -------------------------------------------
            Reinforce Class
        ------------------------------------------- */
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


_baseMap
