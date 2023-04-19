/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_getInfantryClasses

Description:
    Selects the most specific config's infantryClasses property and returns its
     value.

Parameters:
    0: _configClasses <ARRAY> - An array of CONFIGs to select the "infantryClasses"
        property from. If a string, value is found, it will be treated as a function
        that should return an array of classnames.

Returns:
    <ARRAY> - An array of STRING class names

Examples:
    (begin example)
        [
            [
                missionConfigFile >> "KISKA_Bases" >> "myBase",
                missionConfigFile >> "KISKA_Bases" >> "myBase" >> "Infantry",
                missionConfigFile >> "KISKA_Bases" >> "myBase" >> "Infantry" >> "myInfantryClass"
            ]
        ] call KISKA_fnc_bases_getInfantryClasses;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_getInfantryClasses";

params [
    ["_configClasses",[],[[]]]
];

private _infantryClasses = [
    "infantryClasses",
    _configClasses,
    [[],""],
    [123]
] call KISKA_fnc_getMostSpecificCfgValue;

if (isNil "_infantryClasses") exitWith {
    [["No infantryClasses were found at the following configs: ",str _configClasses],true] call KISKA_fnc_log;
    []
};

if (_infantryClasses isEqualType "") then {
    _infantryClasses = [[],_infantryClasses] call KISKA_fnc_callBack;
};


_infantryClasses
