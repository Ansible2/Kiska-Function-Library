/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConfigDataConditional

Description:
    Retrieves the conditional value located in a given config. This code will cache
     configs and their values after being run once within the `localNamespace`.

    The syntax for a conditional config:
    (begin config example)
        // `_conditionalConfigParent` param would be the config path to `MyClass`
        class MyClass
        {
            class KISKA_conditional
            {
                cacheResult = 1; // defaults to true

                class ExampleCondition_1
                {
                    // A list of addon directories (names) as they would appear in getLoadedModsInfo (case-insensitive).
                    // All addons in the list must be loaded.
                    addons[] = { "A3" };

                    // A list of CfgPatches classNames that need to be present.
                    patches[] = { "A3_Data_F"};

                    // Uncompiled code that must return a boolean value.
                    // `false` means the ExampleCondition_1's value will not be used
                        // Parameters: 
                        // 0: <CONFIG> - The parent condition class ("MyConditionalClass")
                        // 1: <CONFIG> - The current conditional class (`"MyClass" >> "KISKA_conditional" >> "ExampleCondition_1"`)
                        // 2: <STRING> - The property being searched for
                    condition = "hint str _this; true";

                    // A class filled with the properties that you can get
                    class properties
                    {
                        exampleProperty_1 = 1;
                    };
                };

                class ExampleCondition_2
                {
                    class properties
                    {
                        exampleProperty_1 = 0;
                        exampleProperty_2 = 1;
                    };
                };
            };

            exampleProperty_1 = "default value";
        };
    (end)

    Configs will be prioritized in the order that they are defined. Meaning in the example above,
     should both `ExampleCondition_1` and `ExampleCondition_2` be met, `ExampleCondition_1` will be used since it is
     defined higher.

    In the case that no conditional classes are met or none exist, the `_conditionalConfigParent`'s 
     scope will be searched for the property using `KISKA_fnc_getConfigData`.

    The result of the value initially calculated after all the condition checks is by default 
     cached with the `cacheResult` property being interpreted as `true`. This means that the compilation
     and run of the `condition` properties of the classes will be performed only once and that
     value will be saved. 

    Another important note, **only** the highest priority conditional classes' values will be
     retrievable. Taking the example above again, the `ExampleCondition_1` class does not have `exampleProperty_2`
     defined. But assuming `ExampleCondition_1`'s conditions are met and it is chosen, `KISKA_fnc_getConfigDataConditional`
     will then return `nil` when searching in `MyConditionalClass` for a value at `exampleProperty_2`.
    
    Should any of the conditional properties (`addons`,`patches`,`condition`) be excluded, they will simply 
     be treated as a `true` value. Meaning that if none of the properties are defined, the conditional class
     will always be valid.

Parameters:
    0: _conditionalConfigParent <CONFIG> - Default: `configNull` - The config path to parse dynamic data from.
        This should include a class underneath it named `KISKA_conditional`.
    1: _property <STRING> - Default: `""` - The config path to parse dynamic data from
    2: _isBool <BOOL> - Default: `false` - Will convert a number value into a `BOOL`. If the value
        is more than `0`, the it will be `true`. Any values `<= 0` will be `false`

Returns:
    <NUMBER | STRING | ARRAY | BOOL> - The value for the given conditional config.
     `nil` in cases where config value is not found or no conditions are met.

Examples:
    (begin example)
        private _value = [
            missionConfigFile >> "KISKA_Bases" >> "MyBase",
            "myProperty"
        ] call KISKA_fnc_getConfigDataConditional;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getConfigDataConditional";

#define GET_PARENT_CONFIG_PROPERTY [_conditionalConfigParent >> _property,_isBool] call KISKA_fnc_getConfigData

params [
    ["_conditionalConfigParent",configNull,[configNull]],
    ["_property","",[""]],
    ["_isBool",false,[true]]
];

if (isNull _conditionalConfigParent) exitWith {
    ["null _conditionalConfigParent provided",true] call KISKA_fnc_log;
    nil
};

private _conditionalConfig = _conditionalConfigParent >> "KISKA_conditional";
if !(isClass _conditionalConfig) exitWith {
    [
        ["No 'KISKA_conditional' class exists under",_conditionalConfigParent],
        false
    ] call KISKA_fnc_log;
    
    GET_PARENT_CONFIG_PROPERTY
};


private _cachedResultMap = localNamespace getVariable "KISKA_conditionalConfig_cachedResultMap";
if (isNil "_cachedResultMap") then {
    _cachedResultMap = createHashMap;
    localNamespace setVariable ["KISKA_conditionalConfig_cachedResultMap",_cachedResultMap];
};
private _cachekey = [_conditionalConfig,_property] joinString "/";
if (_cachekey in _cachedResultMap) exitWith {_cachedResultMap get _cachekey};



private _modDirectoriesLowered = uiNamespace getVariable "KISKA_conditionalConfig_loadedMods";
if (isNil "_modDirectoriesLowered") then {
    _modDirectoriesLowered = (call KISKA_fnc_getLoadedModsInfo) apply { 
        private _modDirectoryName = _x select 1;
        toLowerANSI _modDirectoryName   
    };
    uiNamespace setVariable ["KISKA_conditionalConfig_loadedMods",_modDirectoriesLowered];
};
private _conditionalClassesMap = localNamespace getVariable "KISKA_conditionalConfig_parsedConfigMap";
if (isNil "_conditionalClassesMap") then {
    _conditionalClassesMap = createHashMap;
    localNamespace setVariable ["KISKA_conditionalConfig_parsedConfigMap",_conditionalClassesMap];
};


/* ----------------------------------------------------------------------------
    Use cache if available
---------------------------------------------------------------------------- */
private _alreadyParsedConfigs = _conditionalClassesMap get _conditionalConfig;
private _conditionArgs = [_conditionalConfig,configNull,_property];
private "_propertyValue";
if !(isNil "_alreadyParsedConfigs") exitWith {
    _alreadyParsedConfigs apply {
        _x params ["_conditionalClassConfig","_condition"];
        _conditionArgs set [1,_conditionalClassConfig];

        if (
            (_condition call KISKA_fnc_isEmptyCode) OR 
            {_conditionArgs call _condition}
        ) then {
            _propertyValue = [
                _conditionalClassConfig >> "properties" >> _property,
                _isBool
            ] call KISKA_fnc_getConfigData;

            break;
        };
    };

    if (isNil "_propertyValue") then { _propertyValue = GET_PARENT_CONFIG_PROPERTY };
    _propertyValue
};



/* ----------------------------------------------------------------------------
    Create cache
---------------------------------------------------------------------------- */
private _conditionalConfigClasses = configProperties [_conditionalConfig,"isClass _x"];
_alreadyParsedConfigs = [];
_conditionalConfigClasses apply {
    private _meetsStaticRequirements = true;

    private _requiredPatches = getArray(_x >> "patches");
    _requiredPatches apply {
        if ([_x] call KISKA_fnc_isPatchLoaded) then { continue };
        _meetsStaticRequirements = false;
        break;
    };
    if !(_meetsStaticRequirements) then { continue };


    private _requiredAddons = getArray(_x >> "addons");
    _requiredAddons apply {
        if ((toLowerANSI _x) in _modDirectoriesLowered) then { continue };
        _meetsStaticRequirements = false;
        break;
    };
    if !(_meetsStaticRequirements) then { continue };

    
    private _condition = compileFinal (getText(_x >> "condition"));
    _alreadyParsedConfigs pushBack [_x,_condition];


    _conditionArgs set [1,_x];
    if (
        (isNil "_propertyValue") AND 
        {
            (_condition call KISKA_fnc_isEmptyCode) OR 
            {_conditionArgs call _condition}
        }
    ) then {
        _propertyValue = [
            _x >> "properties" >> _property,
            _isBool
        ] call KISKA_fnc_getConfigData;
    };
};

_conditionalClassesMap set [_conditionalConfig,_alreadyParsedConfigs];


if (isNil "_propertyValue") then { _propertyValue = GET_PARENT_CONFIG_PROPERTY };


private _cacheResult = [
    _conditionalClassConfig >> "cacheResult",
    _isBool,
    true
] call KISKA_fnc_getConfigData;
if (_cacheResult) then {
    _cachedResultMap set [_cachekey,_propertyValue];
};


_propertyValue
