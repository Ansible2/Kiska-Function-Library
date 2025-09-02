/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConfigData

Description:
    Retrieves the value located at a given config path.

    Faster than `BIS_fnc_getCfgData`.

Parameters:
    0: _config <CONFIG> - Default: `configNull` - The config path to get data from
    1: _isBool <BOOL> - Default: `false` - Will convert a number value into a `BOOL`. If the value
        is more than `0`, the it will be `true`. Any values `<= 0` will be `false`
    2: _defaultValue <NUMBER | STRING | ARRAY | BOOL | NIL> - Default: `nil` -
        In the event that the config value is undefined, this value will be returned.

Returns:
    <NUMBER | STRING | ARRAY | BOOL | NIL> - The value at the given config path, 
        `nil` if undefined and no default value is provided.

Examples:
    (begin example)
        private _value = [
            configFile >> "CfgVehicles" >> "Car" >> "displayname"
        ] call KISKA_fnc_getConfigData;
    (end)

    (begin example)
        private _defaultZeroValue = [
            configFile >> "null" >> "config",
            false,
            0
        ] call KISKA_fnc_getConfigData;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getConfigData";

params [
    ["_config",configNull,[configNull]],
    ["_isBool",false,[true]],
    ["_defaultValue",nil,[true,123,"",[]]]
];

if (isNull _config) exitWith { 
    // nil values as a variable can sometimes throw errors
    if (isNil "_defaultValue") exitWith {};
    _defaultValue 
};
if (isNumber _config) exitWith {
    private _return = getNumber _config;
    if (_isBool) then {
        _return = _return > 0;
    };
    _return
};
if (isText _config) exitWith { getText _config };
if (isArray _config) exitWith { getArray _config };


_defaultValue
