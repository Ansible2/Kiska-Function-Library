/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_inheritsFrom

Description:
    Copied version of the CBA function `CBA_fnc_inheritsFrom`.

    Checks whether a config entry inherits, directly or indirectly, from another
    one. For objects, it is probably simpler to use the *isKindOf* command.

Parameters:
    0: _config <CONFIG> - Class to check if it is a descendent of `_baseConfig`.
    1: _baseConfig <CONFIG> - Potential ancestor config class.

Returns:
    <BOOL> - `true` if `_config` is a decendent of `_baseConfig`

Example:
    (begin example)
        private _rifle = configFile >> "CfgWeapons" >> "m16a4_acg_gl";
        private _baseRifle = configFile >> "CfgWeapons" >> "RifleCore";
        private _inherits = [_rifle, _baseRifle] call KISKA_fnc_CBA_inheritsFrom;
        // => true in this case, since all rifles are descended from RifleCoreprivate 
    (end)

Author(s):
    Sickboy,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_inheritsFrom";

params [
    ["_config", configNull, [configNull]], 
    ["_baseConfig", configNull, [configNull]]
];

private _valid = false;

while {configName _config != ""} do {
    _config = inheritsFrom _config;

    if (_config == _baseConfig) exitWith {
        _valid = true;
    };
};

_valid