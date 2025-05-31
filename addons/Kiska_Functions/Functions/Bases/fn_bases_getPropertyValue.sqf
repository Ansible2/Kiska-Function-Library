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

private _setConditionalValue = [_setConfigPath,_property,_isBool] call KISKA_fnc_getConfigDataConditional;
if !(isNil "_setConditionalValue") exitWith { _setConditionalValue };

private "_propertyValue";
private _configHierarchy = configHierarchy _setConfigPath;
[
    [_canSelectFromSetRoot,2],
    [_canSelectFromBaseRoot,1]
] apply {
    params ["_canSelectRoot","_hierarchyPosition"];
    if !(_canSelectRoot) then { continue };

    private _rootConfig = _configHierarchy select _hierarchyPosition;
    private _rootConditionalValue = [_rootConfig,_property,_isBool] call KISKA_fnc_getConfigDataConditional;
    if !(isNil "_rootConditionalValue") then {
        _propertyValue = _rootConditionalValue;
        break;
    };
};


if !(isNil "_propertyValue") exitWith { _propertyValue };
_default
