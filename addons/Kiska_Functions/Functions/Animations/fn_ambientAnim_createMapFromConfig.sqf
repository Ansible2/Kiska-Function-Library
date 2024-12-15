/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_createMapFromConfig

Description:
    Parses a given config into a hashmap that can be used by KISKA_fnc_ambientAnim.
    This config will then be the hashmap KISKA_ambientAnim_configAnimationSetMap
     with the config as the key.

    See configFile >> "KISKA_AmbientAnimations" for an example of a configed map.
    
    (begin config example)
        class ambientAnimsConfig
        {
            class someAnimSet
            {
                animations[] = {"myAnimation"}; // the only required property of an anim set
            };
        };
    (end)

Parameters:
    0: _config <CONFIG> - A config to parse into a hashmap

Returns:
    <HASHMAP> - A map of the animation sets and their properties.

Examples:
    (begin example)
        private _map = [
            configFile >> "KISKA_AmbientAnimations"
        ] call KISKA_fnc_ambientAnim_createMapFromConfig;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
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


private _fn_getRelativeInfo = {
    params ["_snapToObjectClass"];

    private _relativeInfoArray = getArray(_snapToObjectClass >> "relativeInfo");
    if (_relativeInfoArray isNotEqualTo []) exitWith { _relativeInfoArray };

    [
        getArray(_snapToObjectClass >> "relativePos"),
        getArray(_snapToObjectClass >> "relativeDir"),
        getArray(_snapToObjectClass >> "relativeUp")
    ]
};

private _fn_parseSnapToObjectClass = {
    params ["_snapToObjectsConfig"];
    
    private _snapToObjectClasses = configProperties [_snapToObjectsConfig,"isClass _x"];
    
    private _snapToObjects = [];
    _snapToObjectClasses apply {
        private _snapToObjectClass = _x;
        private _type = toLowerANSI (getText(_snapToObjectClass >> "type"));
        if (_type isEqualTo "") then {
            [["No type found parsing relative object info for ",_snapToObjectClass],true] call KISKA_fnc_log;
            continue;
        };

        private _snapPointClassConfigs = configProperties [_snapToObjectClass >> "snapPoints","isClass _x"];
        private _isNotMultiSnap = _snapPointClassConfigs isEqualTo [];
        if (_isNotMultiSnap) then {
            private _relativeInfo = [_snapToObjectClass] call _fn_getRelativeInfo;
            _snapToObjects pushBack [
                _type,
                _relativeInfo
            ];
            
            continue;
        };


        private _objectSnapPointsHashMap = createHashMap;
        _snapPointClassConfigs apply {
            private "_snapId";
            
            if (isArray(_x >> "snapId")) then {
                _snapId = getArray(_x >> "snapId");

            } else {
                _snapId = getNumber(_x >> "snapId");
                if (_snapId isEqualTo 0) then {
                    [["Found invalid or nonexistent snap id in config: ",_x],true] call KISKA_fnc_log;
                    continue;
                };

            };


            private _relativeInfoArray = [_x] call _fn_getRelativeInfo;
            _objectSnapPointsHashMap set [_snapId,_relativeInfoArray];
        };

        _snapToObjects pushBack [_type, _objectSnapPointsHashMap]

    };

    
    _snapToObjects
};


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

    private _snapToObjectsConfig = _x >> "snapToObjects";

    private _parsedSnapToObjects = [];
    if !(isNull _snapToObjectsConfig) then {
        if (isArray _snapToObjectsConfig) then {
            _parsedSnapToObjects = getArray(_x >> "snapToObjects");

        } else {
            if (isClass _snapToObjectsConfig) then {
                _parsedSnapToObjects = [_snapToObjectsConfig] call _fn_parseSnapToObjectClass;
            };

        };

        if (_parsedSnapToObjects isNotEqualTo []) then {
            private _snapToObjectsMap = createHashMapFromArray _parsedSnapToObjects;
            _animationSetInfo set ["snapToObjectsMap", _snapToObjectsMap];
        };
    };

    private _configClass = _x;
    [
        ["removeAllWeapons","removeAllWeapons"],
        ["removeSecondaryWeapon","removeSecondaryWeapon"],
        ["removeHandgun","removeHandgun"],
        ["removePrimaryWeapon","removePrimaryWeapon"],
        ["attachToLogic","attachToLogic"],
        ["removeBackpack","removeBackpack"],
        ["removeNightVision","removeNightVision"],
        ["canInterpolate","canInterpolate"]
    ] apply {
        _x params ["_hashMapKey","_configPropertyName"];
        private _configValue = [_configClass >> _configPropertyName] call BIS_fnc_getCfgDataBool;
        _animationSetInfo set [_hashMapKey,_configValue];
    };

    _animationMap set [configName _configClass, _animationSetInfo];
};
KISKA_ambientAnim_configAnimationSetMap set [_config, _animationMap];


_animationMap
