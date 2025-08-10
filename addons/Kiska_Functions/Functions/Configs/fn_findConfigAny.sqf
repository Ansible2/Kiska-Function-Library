/* ----------------------------------------------------------------------------
Function: KISKA_fnc_findConfigAny

Description:
    Searchs `missionConfigFile`, `campaignConfigFile`, and the `configFile`
     (in that order) to find a config based upon the sub paths provided.

    Returns the first one it finds.

    The BIS counterpart to this is `BIS_fnc_loadClass` and while it can be about 0.0005-0.0010ms
     faster if the path is short (about 2 entries). It can yield about 0.005ms faster in various cases.

Parameters:
    0: _pathArray : <STRING[]> - A config path broken up into individual pieces

Returns:
    <CONFIG> - The first config path if found or configNull if not

Examples:
    (begin example)
        private _configPath = [["CfgMusic","Music_Intro_02_MissionStart"]] call KISKA_fnc_findConfigAny;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_findConfigAny";

params [
    ["_pathArray",[],[[]]]
];

if (_pathArray isEqualTo []) exitWith {
    ["_pathArray is empty array!",true] call KISKA_fnc_log;
    configNull
};

private _cache = localNamespace getVariable "KISKA_findConfigAny_cache";
if (isNil "_cache") then {
    _cache = createHashmap;
    localNamespace setVariable ["KISKA_findConfigAny_cache",_cache];
};

private _cachedValue = _cache get _pathArray;
if (!isNil "_cachedValue") exitWith { _cachedValue };

private _configFound = false;
private _configReturn = configNull;
[missionConfigFile,campaignConfigFile,configFile] apply {
    private _configPath = _x;
    _pathArray apply {
        // stop going down this config class path does not exist
        private _path = _configPath >> _x;
        if (isNull _path) then {
            _configFound = false;
            break;
        };
        _configPath = _path;
        _configFound = true;
    };

    if (_configFound) then {
        _configReturn = _configPath;
        break;
    };
};


_cache set [_pathArray,_configReturn];
_configReturn
