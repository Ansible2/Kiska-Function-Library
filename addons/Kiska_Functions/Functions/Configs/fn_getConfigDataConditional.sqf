/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConfigDataConditional

Description:
    Retrieves the conditional value located in a given config. This code will cache
     configs and their values after being run once within the `localNamespace`.

    An important note, **only** the highest priority conditional classes' values 
     will be retrievable. 

    See `KISKA_fnc_getConditionalConfigClass` for more details in the selection 
     of a conditional class.

Parameters:
    0: _conditionalConfigParent <CONFIG> - Default: `configNull` - The config path to parse dynamic data from.
        This should include a class underneath it named `KISKA_conditional`.
    1: _property <STRING> - Default: `""` - The config path to parse dynamic data from
    2: _isBool <BOOL> - Default: `false` - Will convert a number value into a `BOOL`. If the value
        is more than `0`, the it will be `true`. Any values `<= 0` will be `false`
    3: _defaultValue <NUMBER | STRING | ARRAY | BOOL | NIL> - Default: `nil` -
        In the event that the config value is undefined, this value will be returned.

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

params [
    ["_conditionalConfigParent",configNull,[configNull]],
    ["_property","",[""]],
    ["_isBool",false,[true]],
    ["_defaultValue",nil,[true,123,"",[]]]
];

private _conditionalConfig = _conditionalConfigParent call KISKA_fnc_getConditionalConfigClass;
[_conditionalConfig >> _property,_isBool,_defaultValue] call KISKA_fnc_getConfigData
