/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_getSide

Description:
	Selects the most specific config's infantryClasses property and returns its
     value.

Parameters:
    0: _configClasses <ARRAY> - An array of CONFIGs to select the "side" property from
        That will be converted from a number in the side

Returns:
    <SIDE> - The returned side for the given configs

Examples:
    (begin example)
		[
            [
                missionConfigFile >> "KISKA_Bases" >> "myBase"
                missionConfigFile >> "KISKA_Bases" >> "myBase" >> "Infantry",
                missionConfigFile >> "KISKA_Bases" >> "myBase" >> "Infantry" >> "myInfantryClass"
            ]
        ] call KISKA_fnc_bases_getSide;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_getSide";

params [
    ["_configClasses",[],[[]]]
];


private _sideId = [
    "side",
    _configClasses,
    [],
    [[],""]
] call KISKA_fnc_getMostSpecificCfgValue;

if (isNil "_sideId") exitWith {
    [["No side found the following configs: ", str _configClasses],true] call KISKA_fnc_log;
    sideUnknown
};
private _side = _sideId call BIS_fnc_sideType;


_side
