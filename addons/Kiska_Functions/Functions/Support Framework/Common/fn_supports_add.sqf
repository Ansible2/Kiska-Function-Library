/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_add

Description:
    Adds a support to the local player's support KISKA support pool.

Parameters:
    0: _param <CONFIG | STRING> - 

Returns:
    <STRING> - The supports id

Examples:
    (begin example)
        [
            "MySupport" // MySupport class is defined in "CfgCommunicationMenu"
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
    _supportConfig = [["CfgCommunicationMenu",_supportConfig]] call KISKA_fnc_findConfigAny;
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


private _onSupportAdded = getText(_supportDetailsConfig >> "onSupportAdded");
private _id = ["KISKA_support"] call KISKA_fnc_generateUniqueId;

if (_onSupportAdded isNotEqualTo "") then {
    private _onSupportAddedMap = [
        localNamespace,
        "KISKA_supports_onSupportAddedMap",
        {createHashMap}
    ] call KISKA_fnc_getOrDefaultSet;

    private _onSupportAddedCompiled = _onSupportAddedMap get _supportConfig;
    if (isNil "_onSupportAddedCompiled") then {
        _onSupportAddedCompiled = compileFinal _onSupportAdded;
        _onSupportAddedMap set [_supportConfig,_onSupportAddedCompiled];
    };

    [_id,_supportConfig,_numberOfUsesLeft] call _onSupportAddedCompiled;
};

_supportMap set [_id, [_supportConfig,_numberOfUsesLeft]];


_id
