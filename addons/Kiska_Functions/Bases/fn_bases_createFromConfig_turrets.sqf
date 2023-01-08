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
    [[_baseConfig, " is a null config path"],true] call KISKA_fnc_log;
    []
};


private _baseMap = [_baseConfig] call KISKA_fnc_bases_getHashmap;
private _base_turretGunners = _baseMap get "turret gunners";
private _base_unitList = _baseMap get "unit list";
private _base_groupList = _baseMap get "group list";

private _turretsConfig = _baseConfig >> "turrets";
private _turretClasses = configProperties [_turretsConfig,"isClass _x"];

/* ----------------------------------------------------------------------------

    Create Turrets

---------------------------------------------------------------------------- */
_turretClasses apply {
    private _turretConfig = _x;
    private _turrets = (_turretConfig >> "turrets") call BIS_fnc_getCfgData;
    if (_turrets isEqualType "") then {
        _turrets = [_turrets] call KISKA_fnc_getMissionLayerObjects;

    } else {
        _turrets = _turrets apply {
            private _turret = missionNamespace getVariable [_x,objNull];
            if (isNull _turret) then {continue};
            _turret
        };

    };

    if (_turrets isEqualTo []) then {
        [["Found no turrets for KISKA base class: ",_turretConfig], true] call KISKA_fnc_log;
        continue;
    };

    private _unitClasses = [
        [_turretConfig,_baseConfig,_turretsConfig]
    ] call KISKA_fnc_bases_getInfantryClasses;

    private _side = [
        [_turretConfig,_baseConfig,_turretsConfig]
    ] call KISKA_fnc_bases_getSide;

    private _enableDynamicSim = [_turretConfig >> "dynamicSim"] call BIS_fnc_getCfgDataBool;
    private _excludeFromHeadlessTransfer = [_turretConfig >> "excludeHCTransfer"] call BIS_fnc_getCfgDataBool;

    private _onUnitCreated = compile getText(_turretConfig >> "onUnitCreated");
    private _onUnitMovedInGunner = compile getText(_turretConfig >> "onUnitMovedInGunner");

    private _reinforceClass = _turretConfig >> "reinforce";
    _turrets apply {
        private _group = createGroup _side;
        private _unitClass = [_unitClasses,""] call KISKA_fnc_selectRandom;
        private _unit = _group createUnit [_unitClass,[0,0,0],[],0,"NONE"];
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

        if (isNull _reinforceClass) then { continue; };
        [_group,_turretConfig] call KISKA_fnc_bases_initReinforceFromClass;
    };

};


_baseMap
