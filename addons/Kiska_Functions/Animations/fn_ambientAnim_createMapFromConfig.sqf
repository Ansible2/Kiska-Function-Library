scriptName "KISKA_fnc_ambientAnim_createMapFromConfig";

params [
    ["_config",configNull,[configNull]]
];

if (isNull _config) exitWith {
    ["Null config passed!",true] call KISKA_fnc_log;
    []
};


private _animationMap = KISKA_ambientAnim_animationSetMap getOrDefault [_config,[]];
if (_animationMap isNotEqualTo []) exitWith {_animationMap};


_animationMap = createHashMap;
private _classes = configProperties [_config, "isClass _x", true];

_classes apply {
    private _animationSetMap = createHashMap;
    private _animations = getArray(_x >> "animations");
    if (_animations isEqualTo []) then {
        [["Class: ", _x," did not have any animations defined and will not be parsed!",true]] call KISKA_fnc_log;
        continue;
    };
    _animationSetMap set ["animations", _animations];


    private _snapToObjects = getArray(_x >> "snapToObjects");
    if (_snapToObjects isNotEqualTo []) then {
        private _snapToObjectsMap = createHashMapFromArray _snapToObjects;
        _animationSetMap set ["snapToObjectsMap", _snapToObjectsMap];
    };


};
KISKA_ambientAnim_animationSetMap set [_config, _animationMap];


_animationMap
