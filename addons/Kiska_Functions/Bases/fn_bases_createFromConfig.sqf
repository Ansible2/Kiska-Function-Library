/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_createFromConfig

Description:
	Spawns a configed KISKA base.

Parameters:
    0: _baseConfig <STRING or CONFIG> - The config path of the base config or if
        in missionConfigFile >> "KISKA_bases" config, its class

Returns:
    <HASHMAP> - a hashmap containing data abou the base:
        "unit list": <ARRAY of OBJECTs> - All spawned units (includes turret units)
        "group list": <ARRAY of GROUPs> - All spawned groups (does NOT include turret units)
        "turret gunners": <ARRAY of OBJECTs> - All turret units
        "infantry units": <ARRAY of OBJECTs> - All infantry spawned units
        "infantry groups": <ARRAY of GROUPs> - All infantry spawned groups
        "patrol units": <ARRAY of OBJECTs> - All patrol spawned units
        "patrol groups": <ARRAY of GROUPs> - All patrol spawned groups
        "land vehicles": <ARRAY of OBJECTs> - All land spawned vehicles
        "land vehicle groups": <ARRAY of GROUPs> - All land vehicle crew groups

Examples:
    (begin example)
		private _baseMap = ["SomeBaseConfig"] call KISKA_fnc_bases_createFromConfig;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_createFromConfig";


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



[_baseConfig] call KISKA_fnc_bases_createFromConfig_turrets;
[_baseConfig] call KISKA_fnc_bases_createFromConfig_infantry;
[_baseConfig] call KISKA_fnc_bases_createFromConfig_patrols;
[_baseConfig] call KISKA_fnc_bases_createFromConfig_landVehicles;
[_baseConfig] call KISKA_fnc_bases_createFromConfig_simples;


// return base map
[_baseConfig] call KISKA_fnc_bases_getHashmap
