/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConfigData

Description:
    Retrieves the value located at a given config path.

    Faster than BIS_fnc_getCfgData.

Parameters:
    0: _config <CONFIG> - Default: `configNull` - The config path to get data from
    1: _isBool <BOOL> - Default: `false` - Will convert a number value into a `BOOL`. If the value
        is more than `0`, the it will be `true`. Any values `<= 0` will be `false`

Returns:
    <NUMBER | STRING | ARRAY | BOOL | NIL> - The value at the given config path, `nil` if undefined.

Examples:
    (begin example)
        private _value = [
            configFile >> "CfgVehicles" >> "Car" >> "displayname"
        ] call KISKA_fnc_getConfigData;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getConfigData";

params [
    ["_config",configNull,[configNull]],
    ["_isBool",false,[true]]
];

if (isNull _config) exitWith { nil };
if (isNumber _config) exitWith {
    private _return = getNumber _config;
    if (_isBool) then {
        _return = _return > 0;
    };
    _return
};
if (isText _config) exitWith { getText _config };
if (isArray _config) exitWith { getArray _config };


nil
