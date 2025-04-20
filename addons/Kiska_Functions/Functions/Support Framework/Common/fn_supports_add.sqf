/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_add

Description:
    Adds a support to the local player's support KISKA support pool.

Parameters:
    0: _supportConfig <CONFIG | STRING> - Config entry of the support. If a string,
        the config is expected to be located under a `"KISKA_Supports"` config
        (e.g. `missionConfigFile >> "KISKA_Supports" >> "MySupport"`) and will
        be found with `KISKA_fnc_findConfigAny`.
    1: _numberOfUsesLeft <NUMBER> - Default: `-1` - The number of support uses left 
        or rounds available to use. If less than 0, the configed value will be used.

Returns:
    <STRING> - The supports id

Examples:
    (begin example)
        [
            "MySupport" // MySupport class is defined in "KISKA_Supports"
        ] call KISKA_fnc_supports_add;
    (end)

    (begin example)
        private _supportId = [
            missionConfigFile >> "CustomSupports >> "MySupport",
            20
        ] call KISKA_fnc_supports_add;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_add";

params [
    ["_supportConfig",configNull,[configNull,""]],
    ["_numberOfUsesLeft",-1,[123]]
];

private _maxAllowedSupports = missionNamespace getVariable ["KISKA_CBA_supportManager_maxSupports",10];
private _supportMap = call KISKA_fnc_supports_getMap;
if ((count _supportMap) >= _maxAllowedSupports) exitWith {
    [["player already has the max number of supports ->",_maxAllowedSupports],true] call KISKA_fnc_log;
    nil
};

if (_supportConfig isEqualType "") then {
    _supportConfig = [["KISKA_Supports",_supportConfig]] call KISKA_fnc_findConfigAny;
};
if (isNull _supportConfig) exitWith {
    ["Could not find _supportConfig",true] call KISKA_fnc_log;
    nil
};

private _supportDetailsConfig = _supportConfig >> "KISKA_supportDetails";
if (_numberOfUsesLeft < 0) then {
    private _roundCountConfig = _supportDetailsConfig >> "roundCount";
    if (isNumber _roundCountConfig) exitWith { _numberOfUsesLeft = getNumber(_roundCountConfig); };

    private _useCountConfig = _supportDetailsConfig >> "useCount";
    if (isNumber _useCountConfig) exitWith { _numberOfUsesLeft = getNumber(_useCountConfig); };
    
    _numberOfUsesLeft = 1;
};
if (_numberOfUsesLeft isEqualTo 0) exitWith {
    [
        [
            "Trying to add a support with zero uses left -> ",
            _supportConfig
        ],
        true
    ] call KISKA_fnc_log;
    nil
};


private _id = ["KISKA_support"] call KISKA_fnc_generateUniqueId;
private _onSupportAddedMap = [
    localNamespace,
    "KISKA_supports_onSupportAddedMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _onSupportAddedCompiled = _onSupportAddedMap get _supportConfig;
if (isNil "_onSupportAddedCompiled") then {
    private _onSupportAdded = getText(_supportDetailsConfig >> "onSupportAdded");
    _onSupportAddedCompiled = compileFinal _onSupportAdded;
    _onSupportAddedMap set [_supportConfig,_onSupportAddedCompiled];
};

if (_onSupportAddedCompiled isNotEqualTo {}) then {
    [_id,_supportConfig,_numberOfUsesLeft] call _onSupportAddedCompiled;
};

_supportMap set [_id, [_supportConfig,_numberOfUsesLeft]];

private _notificationClass = _supportDetailsConfig >> "AddedNotifcation";
if (isClass _notificationClass) then {
    [_notificationClass] call KISKA_fnc_showNotification;
};

_id
