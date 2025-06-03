/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_getClassConfig

Description:
    Used to sift through the various levels of possible configs for a KISKA base.

    Very similar to `KISKA_fnc_bases_getPropertyValue` except it's used to obtain
     an entire config class by the given name.

Parameters:
    0: _class <STRING> - The name of the class to obtain.
    1: _setConfigPath <CONFIG> - The config of the base set that is being searched
        (e.g. `missionConfigFile >> "KISKA_Bases" >> "MyBase" >> "infantry" >> "sets" >> "MyInfantrySet"`)
    2: _canSelectFromSetRoot <BOOL> - Whether or not the property can be retrieved from
        the root of the set class (e.g. `missionConfigFile >> "KISKA_Bases" >> "MyBase" >> "infantry"`)
        (Default: `true`)
    3: _canSelectFromBaseRoot <BOOL> - Whether or not the property can be retrieved from
        the root of the KISKA base class (e.g. `missionConfigFile >> "KISKA_Bases" >> "MyBase"`)
        (Default: `true`)

Returns:
    <CONFIG> - The most specific config of the class or `configNull` if not found.

Examples:
    (begin example)
        private _agentsConfig = missionConfigFile >> "KISKA_Bases" >> "MyBase" >> "turrets" >> "sets" >> "agents";
        private _agentsRandomGearConfig = [
            "KISKA_randomGear",
            _agentsConfig,
            true,
            false
        ] call KISKA_fnc_bases_getClassConfig;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_getClassConfig";

params [
    ["_class","",[""]],
    ["_setConfigPath",configNull,[configNull]],
    ["_canSelectFromSetRoot",true,[false]],
    ["_canSelectFromBaseRoot",true,[false]]
];

private _setConfigClass = _setConfigPath >> _class;
if (isClass _setConfigClass) exitWith { _setConfigClass };

private _configClass = configNull;
private _configHierarchy = configHierarchy _setConfigPath;
[
    [_canSelectFromSetRoot,2],
    [_canSelectFromBaseRoot,1]
] apply {
    _x params ["_canSelectRoot","_hierarchyPosition"];
    if !(_canSelectRoot) then { continue };

    private _rootConfig = _configHierarchy select _hierarchyPosition;
    private _rootConfigClass = _rootConfig >> _class;
    if (isClass _rootConfigClass) then { 
        _configClass = _rootConfigClass;
        break; 
    };
};


_configClass
