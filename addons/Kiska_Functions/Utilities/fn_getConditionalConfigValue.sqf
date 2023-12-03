/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConditionalConfigValue

Description:
    Retrieves the conditional value located in a given config. This code will cache
     configs and their values after being run once within the `localNamespace`.

    The syntax for a conditional config:
    (begin config example)
        // `_conditionalConfig` param would be the config path to `MyConditionalClass`
        class MyConditionalClass
        {
            class ExampleCondition_1
            {
                // A list of addon directories (names) as they would appear in getLoadedModsInfo (case-insensitive).
                // All addons in the list must be loaded present.
                addons[] = { "A3" };

                // A list of CfgPatches classNames that need to be present.
                patches[] = { "A3_Data_F"};

                // Uncompiled code that must return a boolean value.
                // `false` means the ExampleCondition_1's value will not be used
                    // Parameters: 
                    // 0: <CONFIG> - The parent condition class (MyConditionalClass)
                    // 1: <CONFIG> - The current conditional class (MyConditionalClass >> ExampleCondition_1)
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
    (end)

    Configs will be prioritized in the order that they are defined. Meaning in the example above,
     should both `ExampleCondition_1` and `ExampleCondition_2` be met, `ExampleCondition_1` will be used since it is
     defined higher.

    Another important note, **only** the highest priority conditional classes' values will be
     retrievable. Taking the example above again, the `ExampleCondition_1` class does not have `exampleProperty_2`
     defined. But assuming `ExampleCondition_1`'s conditions are met and it is chosen, `KISKA_fnc_getConditionalConfigValue`
     will then return `nil` when searching in `MyConditionalClass` for a value at `exampleProperty_2`.
    
    Should any of the conditional properties (`addons`,`patches`,`condition`) be excluded, they will simply 
     be treated as a `true` value. Meaning that if none of the properties are defined, the conditional class
     will always be valid.

Parameters:
    0: _conditionalConfig <CONFIG> - Default: `configNull` - The config path to parse dynamic data from
    1: _property <STRING> - Default: `""` - The config path to parse dynamic data from
    2: _isBool <BOOL> - Default: `false` - Will convert a number value into a `BOOL`. If the value
        is more than `0`, the it will be `true`. Any values `<= 0` will be `false`

Returns:
    <NUMBER | STRING | ARRAY | BOOL> - The value for the given conditional config.
     `nil` in cases where config value is not found or no conditions are met.

Examples:
    (begin example)
        private _value = [
            missionConfigFile >> "KISKA_Bases" >> "MyBase" >> "Conditional",
            "myProperty"
        ] call KISKA_fnc_getConditionalConfigValue;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getConditionalConfigValue";

params [
    ["_conditionalConfig",configNull,[configNull]],
    ["_property","",[""]],
    ["_isBool",false,[true]]
];


if (isNull _conditionalConfig) exitWith {
    ["null config provided",false] call KISKA_fnc_log;
    nil
};

private _loadedModsInfo = call KISKA_fnc_getLoadedModsInfo;
private _modDirectoriesLowered = uiNamespace getVariable "KISKA_conditionalConfig_loadedMods";
if (isNil "_modDirectoriesLowered") then {
    _modDirectoriesLowered = _loadedModsInfo apply { 
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

private "_propertyValue";
private _conditionArgs = [_conditionalConfig,configNull,_property];

private _parsedConditionalConfigs = _conditionalClassesMap get _conditionalConfig;
if !(isNil "_parsedConditionalConfigs") exitWith {
    _parsedConditionalConfigs apply {
        _x params ["_conditionalClassConfig","_condition"];
        _conditionArgs set [1,_conditionalClassConfig];

        if (
            (_condition isEqualTo {}) OR 
            {_conditionArgs call _condition}
        ) then {
            _propertyValue = [
                _conditionalClassConfig >> "properties",
                _property,
                _isBool
            ] call KISKA_fnc_getConfigData;

            break;
        };
    };

    _propertyValue
};


private _conditionalConfigClasses = configProperties [_conditionalConfig,"isClass _x"];
private _parsedConditionalConfigs = [];
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

    
    private _condition = compile (getText(_x >> "condition"));
    _parsedConditionalConfigs pushBack [_x,_condition];


    _conditionArgs set [1,_conditionalClassConfig];
    if (
        (isNil "_propertyValue") AND 
        {
            (_condition isEqualTo {}) OR 
            {_conditionArgs call _condition}
        }
    ) then {
        _propertyValue = [
            _conditionalClassConfig >> "properties",
            _property,
            _isBool
        ] call KISKA_fnc_getConfigData;
    };
};

_conditionalClassesMap set [_conditionalConfig,_parsedConditionalConfigs];


_propertyValue
