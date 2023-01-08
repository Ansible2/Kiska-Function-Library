/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_initReinforceFromClass

Description:
    Parses a reinforce class that is used in a unit's KIKSA bases class, and
    initializes the group(s) reactivity to it.

Parameters:
    0: _group <GROUP, GROUP[]> - The config path of the base config
    1: _config <CONFIG> - The config path of the base config

Returns:
    NOTHING

Examples:
    (begin example)
        [
            _group,
            SomeBaseConfig >> "infantry" >> "someUnitClass"
        ] call KISKA_fnc_bases_initReinforceFromClass;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_initReinforceFromClass";

params [
    ["_group",grpNull,[grpNull,[]]],
    ["_config",configNull,[configNull]]
];

private _groupIsArray = _group isEqualType [];
if ((!_groupIsArray) AND {isNull _group}) exitWith {
    ["_group is null!",true] call KISKA_fnc_log;
    nil
};

if (_groupIsArray AND {_group isEqualTo []}) exitWith {
    ["_group is an empty array!",true] call KISKA_fnc_log;
    nil
};

if (isNull _config) exitWith {
    ["_config is null!",true] call KISKA_fnc_log;
    nil
};


private _reinforceClass = _x >> "reinforce";
if (isNull _reinforceClass) exitWith {
    [
        ["config ",_config," does not have a 'reinforce' class within it!"],
        true
    ] call KISKA_fnc_log;
    nil
};


private _reinforceId = configName _x;
private _idPropertyConfig = _reinforceClass >> "id";
if (isText _idPropertyConfig) then {
    _reinforceId = _idPropertyConfig call BIS_fnc_getCfgData;
};

private _canCallIds = getArray(_reinforceClass >> "canCall");
private _reinforcePriority = getNumber(_reinforceClass >> "priority");
private _onEnemyDetected = getText(_reinforceClass >> "onEnemyDetected");

if (_groupIsArray) exitWith {
    _group apply {
        [
            _x,
            _reinforceId,
            _canCallIds,
            _reinforcePriority,
            _onEnemyDetected
        ] call KISKA_fnc_bases_setupReactivity;
    };

    nil
};


[
    _group,
    _reinforceId,
    _canCallIds,
    _reinforcePriority,
    _onEnemyDetected
] call KISKA_fnc_bases_setupReactivity;


nil
