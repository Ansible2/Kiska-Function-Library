/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_initAmbientAnimFromClass

Description:
    Parses and initializes a KISKA base entry's ambient animation class.

    This is meant to be called from KISKA bases createFromConfig functions.

Parameters:
    0: _configToInit <CONFIG> - The config path to the entry's that has an ambientAnim class
    1: _units <OBJECT[] or OBJECT> - The units that are under the config to init

Returns:
    NOTHING

Examples:
    (begin example)
        [
            missionConfigFile >> "SomeBaseConfig" >> "infantry >> "someInfantryConfigClass",
            someUnit
        ] call KISKA_fnc_bases_initAmbientAnimFromClass;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_initAmbientAnimFromClass";

params [
    ["_configToInit",configNull,[configNull]],
    ["_units",objNull,[[],objNull]]
];

if (isNull _configToInit) exitWith {
    ["Passed a null _configToInit",true] call KISKA_fnc_log;
    nil
};

private _ambientAnimConfig = _configToInit >> "ambientAnim";
if (isNull _ambientAnimConfig) exitWith {
    [["Config: ",_configToInit," does not have an 'ambientAnim' class in it"],false] call KISKA_fnc_log;
    nil
};


private _exitOnCombat = [_ambientAnimConfig >> "exitOnCombat"] call BIS_fnc_getCfgDataBool;
private _equipmentLevel = (_ambientAnimConfig >> "equipmentLevel") call BIS_fnc_getCfgData;
if (isNil "_equipmentLevel") then {
    _equipmentLevel = "";
};


private _animationParams = "";
private _animationSetConfig = _ambientAnimConfig >> "animationSet";
if (isClass _animationSetConfig) then {
    private _snapToAnimationSets = (_animationSetConfig >> "snapToAnimations") call BIS_fnc_getCfgData;
    if (isNil "_snapToAnimationSets") then { _snapToAnimationSets = "" };

    private _backupAnimationSets = (_animationSetConfig >> "backupAnimations") call BIS_fnc_getCfgData;
    if (isNil "_backupAnimationSets") then { _backupAnimationSets = "" };

    private _snapToRange = getNumber(_animationSetConfig >> "snapToRange");
    private _snapRangeIsUndefined = _snapToRange isEqualTo 0;
    if (_snapRangeIsUndefined) then {
        _snapToRange = 5;
    };
    private _fallbackFunction = getText(_animationSetConfig >> "fallbackFunction");
    
    _animationParams = createHashMapFromArray [
        ["_animSet",_snapToAnimationSets],
        ["_snapToRange",_snapToRange],
        ["_backupAnims",_backupAnimationSets],
        ["_fallbackFunction",_fallbackFunction]
    ];

} else {
    _animationParams = _animationSetConfig call BIS_fnc_getCfgData;
};



private _args = [
    _units,
    _animationParams,
    _exitOnCombat,
    _equipmentLevel
];

private _getAnimationMapFunction = getText(_ambientAnimConfig >> "getAnimationMapFunction");
if (_getAnimationMapFunction isNotEqualTo "") then {
    private _animationMap = [[],_getAnimationMapFunction] call KISKA_fnc_callBack;
    _args pushBack _animationMap;
};

_args call KISKA_fnc_ambientAnim;


nil
