/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_initAmbientAnimFromClass

Description:
    Parses and initializes a KISKA base entry's ambient animation class.

Parameters:
    0: _configToInit <CONFIG> - The config path to the entry's that has an ambientAnim class

Returns:
    NOTHING

Examples:
    (begin example)
        [
            missionConfigFile >> "SomeBaseConfig" >> "infantry >> "someInfantryConfigClass"
        ] call KISKA_fnc_bases_initAmbientAnimFromClass;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_initAmbientAnimFromClass";

params [
    ["_configToInit",configNull,[configNull]]
];

if (isNull _configToInit) exitWith {
    ["Passed a null _configToInit",true] call KISKA_Fnc_log;
    nil
};

private _ambientAnimConfig = _configToInit >> "ambientAnim";
if (isNull _ambientAnimConfig) exitWith {
    [["Config: ",_configToInit," does not have an 'ambientAnim' class in it"]] call KISKA_fnc_log;
    nil
};


private _combat = [_ambientAnimConfig >> "exitOnCombat"] call BIS_fnc_getCfgDataBool;
private _equipmentLevel = (_ambientAnimConfig >> "equipmentLevel") call BIS_fnc_getCfgData;
if (isNil "_equipmentLevel") then {
    _equipmentLevel = "";
};


private _animationParams = "";
private _animationSetConfig = _ambientAnimConfig >> "animationSet";
if (isClass _animationSetConfig) then {
    private _snapToAnimationSets = (_animationSetConfig >> "snapToAnimations") call BIS_fnc_getCfgData;
    private _backupAnimationSets = (_animationSetConfig >> "backupAnimations") call BIS_fnc_getCfgData;
    private _snapToRange = getNumber(_animationSetConfig >> "snapToRange");
    if (_snapToRange isEqualTo 0) then {
        _snapToRange = 5;
    };
    private _fallbackFunction = getText(_animationSetConfig >> "fallbackFunction");

    _animationParams = [
        _snapToAnimationSets,
        _snapToRange,
        _backupAnimationSets,
        _fallbackFunction
    ];

} else {
    _animationParams = _animationSetConfig call BIS_fnc_getCfgData;
};



private _args = [
    _units,
    _animationParams,
    _combat,
    _equipmentLevel,
    _snapToRange,
    _fallbackFunction
];

private _getAnimationMapFunction = getText(_ambientAnimConfig >> "getAnimationMapFunction");
if (_getAnimationMapFunction isNotEqualTo "") then {
    private _animationMap = [[],_getAnimationMapFunction] call KISKA_fnc_callBack;
    _args pushBack _animationMap;
};

_args call KISKA_fnc_ambientAnim;


nil
