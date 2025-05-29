/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_getPropertyValue

Description:
    Used to sift through the various levels of possible properties for a KISKA base.

Parameters:
    0: _property <STRING> - The property to get the value of
    1: _setConfigPath <CONFIG> - The config of the base set that is being searched
        (e.g. `missionConfigFile >> KISKA_Bases >> MyBase >> infantry >> sets >> MyInfantrySet`)
    2: _default <ANY> - The default value to return if the property search returns `nil`
    3: _isBool <BOOL> - Whether or not the property should be interpreted as a 
        boolean value (Default: `false`)
    4: _canSelectFromSetRoot <BOOL> - Whether or not the property can be retrieved from
        the root of the set class (e.g. `missionConfigFile >> KISKA_Bases >> MyBase >> infantr`y)
        (Default: `true`)
    5: _canSelectFromBaseRoot <BOOL> - Whether or not the property can be retrieved from
        the root of the KISKA base class (e.g. `missionConfigFile >> KISKA_Bases >> MyBase`)
        (Default: `true`)

Returns:
    <ANY> - The property value

Examples:
    (begin example)
        private _turretConfig = missionConfigFile >> KISKA_Bases >> MyBase >> turrets >> sets >> MyTurretSet
        private _turretSpawnPositions = [
            "spawnPositions",
            _turretConfig,
            [],
        ] call KISKA_fnc_bases_getPropertyValue;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_getPropertyValue";

params [
    ["_property","",[""]],
    ["_setConfigPath",configNull,[configNull]],
    "_default",
    ["_isBool",false,[false]],
    ["_canSelectFromSetRoot",true,[false]],
    ["_canSelectFromBaseRoot",true,[false]]
];

private _setPropertyConfig = _setConfigPath >> _property;
if !(isNull _setPropertyConfig) exitWith {
    [_setPropertyConfig,_isBool] call KISKA_fnc_getConfigData
};

private _setConditionalValue = [_setConfigPath >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
if !(isNil "_setConditionalValue") exitWith { _setConditionalValue };

private "_propertyValue";
private _configHierarchy = configHierarchy _setConfigPath;
if (_canSelectFromSetRoot) then {
    private _setRootConfig = _configHierarchy select 2;
    private _setRootPropertyConfigPath = _setRootConfig >> _property;
    if !(isNull _setRootPropertyConfigPath) exitWith {
        _propertyValue = [_setRootPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
    };

    private _setRootConditionalValue = [_setRootConfig >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
    if !(isNil "_setRootConditionalValue") exitWith { _propertyValue = _setRootConditionalValue };
};

if (_canSelectFromBaseRoot AND (isNil "_propertyValue")) then {
    private _baseRootConfig = _configHierarchy select 1;
    private _baseRootPropertyConfigPath = _baseRootConfig >> _property;
    if !(isNull _baseRootPropertyConfigPath) exitWith {
        _propertyValue = [_baseRootPropertyConfigPath,_isBool] call KISKA_fnc_getConfigData
    };

    private _baseRootConditionalValue = [_baseRootConfig >> "conditional",_property] call KISKA_fnc_getConditionalConfigValue;
    if !(isNil "_baseRootConditionalValue") exitWith { _propertyValue = _baseRootConditionalValue };
};


if (isNil "_propertyValue") then {
    _default
} else {
    _propertyValue
};