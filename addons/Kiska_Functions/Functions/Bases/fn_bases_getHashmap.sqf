/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_getHashmap

Description:
    Returns a KISKA bases' hashmap spawn data or initializes if it did not exist.

Parameters:
    0: _baseConfig <CONFIG or STRING> - The config path of the base config

Returns:
    <HASHMAP> - a hashmap containing data about the base:

    - `unit list`: <OBJECT[]> - All spawned units (includes turret units, 
        DOES NOT include simple units)
    - `group list`: <GROUP[]> - All spawned groups (does NOT include turret units)
    - `turret gunners`: <OBJECT[]> - All turret units
    - `infantry units`: <OBJECT[]> - All infantry spawned units
    - `infantry groups`: <GROUP[]> - All infantry spawned groups
    - `patrol units`: <OBJECT[]> - All patrol spawned units
    - `patrol groups`: <GROUP[]> - All patrol spawned groups
    - `land vehicles`: <OBJECT[]> - All land spawned vehicles
    - `land vehicle groups`: <GROUP[]> - All land vehicle crew groups
    - `agent list`: <OBJECT[]> - All spawned agents
    - `simple units`: <OBJECT[]> - All spawned simple units

Examples:
    (begin example)
        private _mapOfDataForSpecificBase = [
            "SomeBaseConfig"
        ] call KISKA_fnc_bases_getHashmap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_getHashmap";

params [
    ["_baseConfig",configNull,["",configNull]]
];


if (_baseConfig isEqualType "") then {
    _baseConfig = missionConfigFile >> "KISKA_Bases" >> _baseConfig;
};
if (isNull _baseConfig) exitWith {
    ["A null _baseConfig was passed",true] call KISKA_fnc_log;
    []
};


private _baseName = configName _baseConfig;
if (isNil "KISKA_bases_map") then {
    missionNamespace setVariable ["KISKA_bases_map",createHashMap];
};

private _baseData = KISKA_bases_map getOrDefault [_baseName, -1];
if (_baseData isNotEqualTo -1) exitWith {_baseData};


_baseData = createHashMapFromArray [
    ["unit list",[]],
    ["group list",[]],
    ["turret gunners",[]],
    ["infantry units",[]],
    ["infantry groups",[]],
    ["patrol units",[]],
    ["patrol groups",[]],
    ["land vehicles",[]],
    ["land vehicle groups",[]],
    ["agent list",[]],
    ["simple units",[]]
];
KISKA_bases_map set [_baseName,_baseData];


_baseData
