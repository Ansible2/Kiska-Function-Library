/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_createMapFromConfig

Description:
    Parses a given config into a hashmap that can be used by KISKA_fnc_ambientAnim.
    This config will then be the hashmap KISKA_ambientAnim_configAnimationSetMap
     with the config as the key.

    See configFile >> "KISKA_AmbientAnimations" for an example of a configed map.

    class ambientAnimsConfig
    {
        class someAnimSet
        {
            animations[] = {"myAnimation"}; // the only required property of an anim set
        };
    };

Parameters:
	0: _config <CONFIG> - A config to parse into a hashmap

Returns:
    <HASHMAP> -  A map of the animation sets and their properties.

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

    private _snapToObjects = [];
    if !(isNull _snapToObjectsConfig) then {
        if (isArray _snapToObjectsConfig) then {
            _snapToObjects = getArray(_x >> "snapToObjects");
        };

        if (isClass _snapToObjectsConfig) then {
            private _snapToObjectClasses = configProperties [_snapToObjectsConfig,"isCLass _x"];
            _snapToObjectClasses apply {
                private _objectClassConfig = _x;
                private _type = getText(_objectClassConfig >> "type");
                if (_type isEqualTo "") then {
                    [["No type found parsing relative object info for ",_objectClassConfig],true] call KISKA_fnc_log;
                    continue;
                };

                private _relativeInfoArray = getArray(_objectClassConfig >> "relativeInfo");
                if (_relativeInfoArray isNotEqualTo []) then {
                    _snapToObjects pushBack [_type, _relativeInfoArray];

                } else {
                    _snapToObjects pushBack [
                        _type,
                        [
                            getText(_objectClassConfig >> "relativePos"),
                            getText(_objectClassConfig >> "relativeDir"),
                            getText(_objectClassConfig >> "relativeUp")
                        ]
                    ];

                };
            };
        };

        if (_snapToObjects isNotEqualTo []) then {
            private _snapToObjectsMap = createHashMapFromArray _snapToObjects;
            _animationSetInfo set ["snapToObjectsMap", _snapToObjectsMap];
        };
    };


    private _removeAllWeapons = [_x >> "removeAllWeapons"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["removeAllWeapons",_removeAllWeapons];

    private _removeBackpack = [_x >> "removeBackpack"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["removeBackpack",_removeBackpack];

    private _removeNightVision = [_x >> "removeNightVision"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["removeNightVision",_removeNightVision];

    private _canInterpolate = [_x >> "canInterpolate"] call BIS_fnc_getCfgDataBool;
    _animationSetInfo set ["canInterpolate",_canInterpolate];


    _animationMap set [configName _x, _animationSetInfo];
};
KISKA_ambientAnim_configAnimationSetMap set [_config, _animationMap];


_animationMap
