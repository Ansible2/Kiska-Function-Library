/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_infantry

Description:
	Spawns a configed KISKA bases' infantry.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

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
private _infantryConfig = _baseConfig >> "infantry";
private _infantryClasses = configProperties [_infantryConfig,"isClass _x"];
private _infantryClassUnitClasses = getArray(_infantryConfig >> "infantryClasses");

private _baseUnitClasses = getArray(_baseConfig >> "infantryClasses");
private _fn_getUnitClasses = {
    params ["_configClass","_moduleUnitClasses"];

    private _unitClasses = getArray(_configClass >> "infantryClasses");
    if (_unitClasses isEqualTo []) then {
        if (_infantryClassUnitClasses isNotEqualTo []) then {
            _unitClasses = _infantryClassUnitClasses;
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
_infantryClasses apply {
    private _classConfig = _x;
    private _spawnPositions = (_classConfig >> "positions") call BIS_fnc_getCfgData;
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


    private _animateClass = _classConfig >> "ambientAnim";
    if !(isNull _animateClass) then {
        private _animationSet = getText(_animateClass >> "animationSet");
        if (_animationSet isEqualTo "") then {_equipmentLevel = "STAND"};

        private _equipmentLevel = getText(_animateClass >> "equipmentLevel");
        if (_equipmentLevel isEqualTo "") then {_equipmentLevel = "ASIS"};

        private _conditionToExit = getText(_animateClass >> "conditionToExit");
        _conditionToExit = compile _conditionToExit;
        if (_conditionToExit isEqualTo {}) then {
            _conditionToExit = { false };
        };

        private _behaviourAfterExit = getText(_animateClass >> "behaviourAfterExit");
        if (_behaviourAfterExit isEqualTo "") then {_behaviourAfterExit = "COMBAT"};

        private _combat = [_x >> "combat"] call BIS_fnc_getCfgDataBool;
        if (_combat) exitWith {
            _units apply {
                [
                    _x,
                    _animationSet,
                    _equipmentLevel,
                    _conditionToExit,
                    _behaviourAfterExit
                ] call BIS_fnc_ambientAnimCombat;
            };
        };

        private _interpolate = [_x >> "interpolate"] call BIS_fnc_getCfgDataBool;
        // attachToLogic in BIS_fnc_ambientAnim is default true,
        // this ensures that intention if dontAttachToLogic is undefined in the config
        private _attachToLogic = !([_x >> "dontAttachToLogic"] call BIS_fnc_getCfgDataBool);
        _units apply {
            [
                _x,
                _animationSet,
                _equipmentLevel,
                objNull,
                _interpolate,
                _attachToLogic
            ] call BIS_fnc_ambientAnim;
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

    private _reinforceId = (_reinforceClass >> "id") call BIS_fnc_getCfgData;
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
