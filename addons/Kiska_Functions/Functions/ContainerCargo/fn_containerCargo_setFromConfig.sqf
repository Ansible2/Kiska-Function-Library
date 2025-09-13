/* ----------------------------------------------------------------------------
Function: KISKA_fnc_containerCargo_setFromConfig

Description:
    Sets (overwrites) the cargo of a given container based on a config defined
     as stated in `KISKA_fnc_containerCargo_getFromConfig`.

Parameters:
    0: _container <OBJECT> - The container to set the cargo of.
    1: _config <CONFIG | STRING> - The config of the container cargo to set on the `_container`.
        If of type STRING, this should be a classname defined in `missionConfigFile >> "KISKA_cargo"`.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            MyContainer,
            missionConfigFile >> "MyContainerCargo"
        ] call KISKA_fnc_containerCargo_setFromConfig;
    (end)

    (begin example)
        [
            MyContainer,
            "MyContainerCargo"
        ] call KISKA_fnc_containerCargo_setFromConfig;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_containerCargo_setFromConfig";

params [
    ["_container",objNull,[objNull]],
    ["_config",configNull,[configNull,""]]
];

if (isNull _container) exitWith {
    ["Null container passed!",true] call KISKA_fnc_log;
    nil
};

if (_config isEqualType "") then {
    _config = missionConfigFile >> "KISKA_cargo" >> _config;
};
if (isNull _config) exitWith {
    ["Null config passed!",true] call KISKA_fnc_log;
    nil
};

[
    _container,
    ([_config] call KISKA_fnc_containerCargo_getFromConfig)
] call KISKA_fnc_containerCargo_set;


nil
