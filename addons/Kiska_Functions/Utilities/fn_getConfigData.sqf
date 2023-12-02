/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getConfigData

Description:
    Retrieves the value located at a given config path.

    Faster than BIS_fnc_getCfgData.

Parameters:
    0: _config <CONFIG> - The config path to get data from
    1: _isBool <BOOL> - Will convert a number value into a `BOOL`. If the value
        is more than `0`, the it will be `true`. Any values `<= 0` will be `false`

Returns:
    <NUMBER | STRING | ARRAY | BOOL> - The value at the given config path

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
    ["_cfg",configNull,[configNull]],
    ["_isBool",false,[true]]
];

if (isNumber _cfg) exitWith {
    private _return = getNumber _cfg;
    if (_isBool) then {
        _return = _return > 0;
    };
    _return
};
if (isText _cfg) exitWith { getText _cfg };
if (isArray _cfg) exitWith { getArray _cfg };


nil
