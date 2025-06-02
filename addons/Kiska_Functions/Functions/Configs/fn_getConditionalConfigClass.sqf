/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConditionalConfigClass

Description:
    Similar to `KISKA_fnc_getConfigDataConditional` except this will return the
     selected conditional class's config instead of a given value in the class.
    
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

    Should any of the conditional properties (`addons`,`patches`,`condition`) be excluded, they will simply 
     be treated as a `true` value. Meaning that if none of the properties are defined, the conditional class
     will always be valid.

Parameters:
    0: _conditionalConfigParent <CONFIG> - Default: `configNull` - The config path 
        to parse dynamic data from. This should include a class underneath it 
        named `KISKA_conditional`.

Returns:
    <CONFIG> - The conditional config class, `configNull` in the event a
        config can't be found.

Examples:
    (begin example)
        (missionConfigFile >> "MyClass") call KISKA_fnc_getConditionalConfigClass
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getConditionalConfigClass";

params [
    ["_conditionalConfigParent",configNull,[configNull]]
];


if (isNull _conditionalConfigParent) exitWith {
    ["null _conditionalConfigParent provided",true] call KISKA_fnc_log;
    configNull
};
private _conditionalConfig = _conditionalConfigParent >> "KISKA_conditional";
if !(isClass _conditionalConfig) exitWith {
    [
        ["No 'KISKA_conditional' class exists under",_conditionalConfigParent],
        false
    ] call KISKA_fnc_log;
    
    _conditionalConfigParent
};


private _cachedResultMap = localNamespace getVariable "KISKA_conditionalConfig_cachedResultMap";
if (isNil "_cachedResultMap") then {
    _cachedResultMap = createHashMap;
    localNamespace setVariable ["KISKA_conditionalConfig_cachedResultMap",_cachedResultMap];
};
if (_conditionalConfig in _cachedResultMap) exitWith {_cachedResultMap get _conditionalConfig};




/* ----------------------------------------------------------------------------
    Use cache if available
---------------------------------------------------------------------------- */
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

private _alreadyParsedConfigs = _conditionalClassesMap get _conditionalConfig;
private "_conditionalConfigClass";
if !(isNil "_alreadyParsedConfigs") exitWith {
    _alreadyParsedConfigs apply {
        _x params ["_parsedClass","_condition"];
        _conditionArgs set [1,_parsedClass];

        if (
            (_condition call KISKA_fnc_isEmptyCode) OR 
            {[_conditionalConfig,_parsedClass] call _condition}
        ) then {
            _conditionalConfigClass = _parsedClass >> "properties";
            break;
        };
    };

    if (isNil "_conditionalConfigClass") exitWith { _conditionalConfigParent };
    _conditionalConfigClass
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
    if (
        (isNil "_conditionalConfigClass") AND 
        {
            (_condition call KISKA_fnc_isEmptyCode) OR 
            {[_conditionalConfig,_parsedClass] call _condition}
        }
    ) then { _conditionalConfigClass = _x >> "properties" };
};
_conditionalClassesMap set [_conditionalConfig,_alreadyParsedConfigs];



if (isNil "_conditionalConfigClass") then { _conditionalConfigClass = _conditionalConfigParent };

private _cacheResult = [
    _conditionalClassConfig >> "cacheResult",
    _isBool,
    true
] call KISKA_fnc_getConfigData;
if (_cacheResult) then {
    _cachedResultMap set [_conditionalConfig,_conditionalConfigClass];
};


_conditionalConfigClass
