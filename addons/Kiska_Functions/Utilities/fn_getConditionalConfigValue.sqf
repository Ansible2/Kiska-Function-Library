/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConditionalConfigValue

Description:
    Retrieves the conditional value located in a given config. This code will cache
     configs and their values after being run once within the `localNamespace`.

    The syntax for a conditional config:
    (begin config example)
        // `_config` param would be the config path to `MyConditionalClass`
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

                exampleProperty_1 = 1;
            };

            class ExampleCondition_2 : ExampleCondition_1
            {
                exampleProperty_1 = 0;
                exampleProperty_2 = 1;
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

Parameters:
    0: _config <CONFIG> - Default: `configNull` - The config path to parse dynamic data from
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
    ["_config",configNull,[configNull]],
    ["_property","",[""]],
    ["_isBool",false,[true]]
];



private _loadedModsInfo = call KISKA_fnc_getLoadedModsInfo;
// TODO cache
private _mods = _loadedModsInfo apply { 
    private _modDirectoryName = _x select 1;
    toLowerANSI _modDirectoryName   
};

// TODO: parse condition classes