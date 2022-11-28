/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_getHashmap

Description:
	Returns a KISKA bases' hashmap spawn data or initializes if it did not exist.

Parameters:
    0: _baseConfig <CONFIG or STRING> - The config path of the base config

Returns:
    <HASHMAP> - a hashmap containing data about the base:
        "unit list": <ARRAY of OBJECTs> - All spawned units (includes turret units)
        "group list": <ARRAY of GROUPs> - All spawned groups (does NOT include turret units)
        "turret gunners": <ARRAY of OBJECTs> - All turret units
        "infantry units": <ARRAY of OBJECTs> - All infantry spawned units
        "infantry groups": <ARRAY of GROUPs> - All infantry spawned groups
        "patrol units": <ARRAY of OBJECTs> - All patrol spawned units
        "patrol groups": <ARRAY of GROUPs> - All patrol spawned groups
        "land vehicles": <ARRAY of OBJECTs> - All land spawned vehicles
        "land vehicle groups": <ARRAY of GROUPs> - All land vehicle crew groups
        "agent list": <ARRAY of OBJECTs> - All spawned agents

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
    [[_baseConfig, " is a null config path"],true] call KISKA_fnc_log;
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
    ["agent list",[]]
];
KISKA_bases_map set [_baseName,_baseData];


_baseData
