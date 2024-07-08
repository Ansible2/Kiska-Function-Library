/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig_simples

Description:
    Spawns a configed KISKA bases' simple objects.

Parameters:
    0: _baseConfig <CONFIG> - The config path of the base config

Returns:
    <HASHMAP> - see KISKA_fnc_bases_getHashmap

Examples:
    (begin example)
        [
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_createFromConfig_simples;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig_simples";

#define DEFAULT_SIMPLE_OFFSET [0, 0, 0.1]

#define SIMPLE_DATA_INDEX_TYPEISCODE 0
#define SIMPLE_DATA_INDEX_TYPE 1
#define SIMPLE_DATA_INDEX_OFFSET 2
#define SIMPLE_DATA_INDEX_VECTORUP 3
#define SIMPLE_DATA_INDEX_VECTORDIR 4
#define SIMPLE_DATA_INDEX_ANIMATIONS 5
#define SIMPLE_DATA_INDEX_SELECTIONS 6
#define SIMPLE_DATA_INDEX_CREATED_EVENT 7
#define SIMPLE_DATA_INDEX_FOLLOW_TERRAIN 8
#define SIMPLE_DATA_INDEX_SUPERSIMPLE 9


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
private _simplesConfig = _baseConfig >> "simples";
private _simpleConfigSets = configProperties [_simplesConfig,"isClass _x"];


private _simpleObjectClassCache = createHashMap;
private _fn_getSimpleClassData = {
    params ["_simpleObjectClass"];

    if (_simpleObjectClass in _simpleObjectClassCache) exitWith {
        _simpleObjectClassCache get _simpleObjectClass
    };

    private _dataArray = [];

    private _typeIsCode = [
        "TYPE_IS_CODE",
        _simpleObjectClass,
        false,
        true,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _typeIsCode;

    private _type = [
        "type",
        _simpleObjectClass,
        "",
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    if (_typeIsCode) then {
        _type = compileFinal _type;
    };
    _dataArray pushBack _type;

    private _offset = [
        "offset",
        _simpleObjectClass,
        DEFAULT_SIMPLE_OFFSET,
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _offset;

    private _vectorUp = [
        "vectorUp",
        _simpleObjectClass,
        [],
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _vectorUp;

    private _vectorDir = [
        "vectorDir",
        _simpleObjectClass,
        [],
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _vectorDir;

    private _animations = [
        "animations",
        _simpleObjectClass,
        [],
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _animations;

    private _selections = [
        "selections",
        _simpleObjectClass,
        [],
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _selections;

    private _onObjectCreated = [
        "onObjectCreated",
        _simpleObjectClass,
        "",
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack (compileFinal _onObjectCreated);

    private _followTerrain = [
        "followTerrain",
        _simpleObjectClass,
        true,
        true,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _followTerrain;

    private _superSimple = [
        "superSimple",
        _simpleObjectClass,
        true,
        true,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    _dataArray pushBack _superSimple;

    
    _simpleObjectClassCache set [_simpleObjectClass,_dataArray];


    _dataArray
};



_simpleConfigSets apply {
    private _simpleSetRootConfig = _x;
    private _simpleObjectClassesInSet = configProperties [_simpleSetRootConfig,"isClass _x"];

    if (_simpleObjectClassesInSet isEqualTo []) then {
        [
            [
                "Skipped simple bases class: ",_simpleSetRootConfig,
                " because no simple classes were found"
            ]
        ] call KISKA_fnc_log;

        continue;
    };

    private _spawnPositions = [
        "spawnPositions",
        _simpleSetRootConfig,
        [],
        false,
        false,
        false
    ] call KISKA_fnc_bases_getPropertyValue;
    if (_spawnPositions isEqualType "") then {
        _spawnPositions = [_spawnPositions] call KISKA_fnc_getMissionLayerObjects;
    };
    if (_spawnPositions isEqualTo []) then {
        [["Could not find spawn positions for KISKA bases class: ",_simpleSetRootConfig],true] call KISKA_fnc_log;
        continue;
    };

    _spawnPositions apply {
        private _objectDirection = 0;
        if ((count _x) > 3) then {
            _objectDirection = _x deleteAt 3;
        };
        // TODO: get objectType
        private _simpleObjectClass = selectRandom _simpleObjectClassesInSet;
        private _simpleClassDataParsed = [_simpleObjectClass] call _fn_getSimpleClassData;
        private _object = [
            _objectType,
            _x,
            _objectDirection,
            _objectData select SIMPLE_DATA_INDEX_FOLLOW_TERRAIN,
            _objectData select SIMPLE_DATA_INDEX_SUPERSIMPLE
        ] call BIS_fnc_createSimpleObject;
    };
};



_baseMap







/* ----------------------------------------------------------------------------

    Helper functions

---------------------------------------------------------------------------- */
private _configDataHashMap = createHashMap;
private _fn_getSimpleClassData = {
    params ["_config"];

    private "_dataArray";
    if (_config in _configDataHashMap) then {
        _dataArray = _configDataHashMap get _config;

    } else {
        _dataArray = [];
        
        private "_type";
        private _getTypeFunction = getText(_config >> "getTypeFunction");
        if (_getTypeFunction isNotEqualTo "") then {
            _type = [[_config],_getTypeFunction] call KISKA_fnc_callBack;
        } else {
            _type = (_config >> "type") call BIS_fnc_getCfgData;
        };
        _dataArray pushBack _type;


        private _offsetConfig = _config >> "offset";
        if (isArray _offsetConfig) then {
            _dataArray pushBack (getArray _offsetConfig);
        } else {
            _dataArray pushBack [0,0,0.1];
        };

        _dataArray pushBack (getArray(_config >> "vectorUp"));
        _dataArray pushBack (getArray(_config >> "vectorDir"));
        _dataArray pushBack (getArray(_config >> "animations"));
        _dataArray pushBack (getArray(_config >> "selections"));
        _dataArray pushBack (compile (getText(_config >> "onObjectCreated")));

        private _followTerrainConfig = _config >> "followTerrain";
        if (isNumber _followTerrainConfig) then {
            _dataArray pushBack ([_followTerrainConfig] call BIS_fnc_getCfgDataBool);

        } else {
            _dataArray pushBack true;

        };

        private _superSimpleConfig = _config >> "superSimple";
        if (isNumber _superSimpleConfig) then {
            _dataArray pushBack ([_superSimpleConfig] call BIS_fnc_getCfgDataBool);

        } else {
            _dataArray pushBack true;

        };

        _configDataHashMap set [_config,_dataArray];
    };


    _dataArray
};

private _fn_getTypeConfigs = {
    params ["_parentConfig"];
    
    private _unfilteredTypeConfigs = configProperties [_parentConfig,"isClass _x"];
    private _filteredTypeConfigs = [];

    _unfilteredTypeConfigs apply {
        private _filterCondition = getText(_x >> "filterCondition");
        
        private _conditionIsNotDefined = _filterCondition isEqualTo "";
        if (
            _conditionIsNotDefined OR
            { [_x] call (compile _filterCondition) }
        ) then {
            _filteredTypeConfigs pushBack _x;
        };
    };


    _filteredTypeConfigs
};

/* ----------------------------------------------------------------------------

    Create objects

---------------------------------------------------------------------------- */
private [
    "_objectDirection",
    "_offset",
    "_vectorUp",
    "_vectorDir",
    "_animations",
    "_selections",
    "_onObjectCreated"
];
_simplesConfigClasses apply {
    private _topConfig = _x;
    private _typeConfigs = [_topConfig] call _fn_getTypeConfigs;
    if (_typeConfigs isEqualTo []) then {
        [
            [
                "Skipped simple bases class: ",_topConfig,
                " because no simple classes were found after filtering"
            ]
        ] call KISKA_fnc_log;

        continue;
    };


    private _positions = (_topConfig >> "positions") call BIS_fnc_getCfgData;
    if (_positions isEqualType "") then {
        private _layerObjects = [_positions] call KISKA_fnc_getMissionLayerObjects;
        _positions = _layerObjects apply {
            private _position = getPosASL _x; // TODO: This may need to be positions world?
            _position pushBack (getDir _x);

            _position
        };
    };

    if (_positions isEqualTo []) then {
        [
            [
                "Skipped simple bases class: ",_topConfig,
                " because no positions were found"
            ]
        ] call KISKA_fnc_log;

        continue;
    };


    _positions apply {
        if (count _x > 3) then {
            _objectDirection = _x deleteAt 3;
        } else {
            _objectDirection = 0;
        };

        private _objectClass = selectRandom _typeConfigs;
        private _objectData = [_objectClass] call _fn_getSimpleClassData;
        private _objectType = _objectData select SIMPLE_DATA_INDEX_TYPE;
        if (_objectType isEqualType []) then {
            _objectType = [_objectType,""] call KISKA_fnc_selectRandom;
        };

        private _object = [
            _objectType,
            _x,
            _objectDirection,
            _objectData select SIMPLE_DATA_INDEX_FOLLOW_TERRAIN,
            _objectData select SIMPLE_DATA_INDEX_SUPERSIMPLE
        ] call BIS_fnc_createSimpleObject;


        _offset = _objectData select SIMPLE_DATA_INDEX_OFFSET;
        if (_offset isNotEqualTo []) then {
            _object setPosASL (_x vectorAdd _offset);
        };

        _vectorDir = _objectData select SIMPLE_DATA_INDEX_VECTORDIR;
        if (_vectorDir isNotEqualTo []) then {
            _object setVectorDir _vectorDir;
        };

        _vectorUp = _objectData select SIMPLE_DATA_INDEX_VECTORUP;
        if (_vectorUp isNotEqualTo []) then {
            _object setVectorUp _vectorUp;
        };

        (_objectData select SIMPLE_DATA_INDEX_ANIMATIONS) apply {
            _object animate [_x select 0, _x select 1, true];
        };
        (_objectData select SIMPLE_DATA_INDEX_SELECTIONS) apply {
            _object hideSelection [_x select 0, (_x select 1) > 0];
        };

        _onObjectCreated = _objectData select SIMPLE_DATA_INDEX_CREATED_EVENT;
        if (_onObjectCreated isNotEqualTo {}) then {
            [
                _onObjectCreated,
                [_object]
            ] call CBA_fnc_directCall;
        };
    };
};


_baseMap
