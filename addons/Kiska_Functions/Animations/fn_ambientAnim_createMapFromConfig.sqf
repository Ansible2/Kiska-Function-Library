scriptName "KISKA_fnc_ambientAnim_createMapFromConfig";

params [
    ["_config",configNull,[configNull]]
];

if (isNull _config) exitWith {
    ["Null config passed!",true] call KISKA_fnc_log;
    []
};


if (isNil "KISKA_ambientAnim_configAnimationSetMap") then {
    missionNamespace setVariable ["KISKA_ambientAnim_configAnimationSetMap",createHashMap];
};

private _animationMap = KISKA_ambientAnim_configAnimationSetMap getOrDefault [_config,[]];
if (_animationMap isNotEqualTo []) exitWith {_animationMap};


_animationMap = createHashMap;
private _classes = configProperties [_config, "isClass _x", true];

_classes apply {
    // map for specific animation set class
    private _animationSetInfo = createHashMap;
    private _animations = getArray(_x >> "animations");
    if (_animations isEqualTo []) then {
        [["Class: ", _x," did not have any animations defined and will not be parsed!",true]] call KISKA_fnc_log;
        continue;
    };
    _animationSetInfo set ["animations", _animations];


    private _snapToObjects = getArray(_x >> "snapToObjects");
    if (_snapToObjects isNotEqualTo []) then {
        private _snapToObjectsMap = createHashMapFromArray _snapToObjects;
        _animationSetInfo set ["snapToObjectsMap", _snapToObjectsMap];
    };


    private _removeAllWeapons = [_x >> "removeAllWeapons"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["removeAllWeapons",_removeAllWeapons];

    private _removeBackpack = [_x >> "removeBackpack"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["removeBackpack",_removeBackpack];

    private _removeNightVision = [_x >> "removeNightVision"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["removeNightVision",_removeNightVision];


    _animationMap set [configName _x, _animationSetInfo];
};
KISKA_ambientAnim_configAnimationSetMap set [_config, _animationMap];


_animationMap
