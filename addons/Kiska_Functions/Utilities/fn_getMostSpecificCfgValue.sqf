/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getMostSpecificCfgValue

Description:
	Picks the most specific unitTypes property from a list of configs.

Parameters:
    0: _property <STRING> - The config property to search for in all of the classes
    1: _configs <ARRAY> - An array of CONFIGs that you would like to look for the
        property. These should be within the same configHierarchy.
    2: _ignoredValue <ARRAY, NUMBER, or STRING> - What is considered an invalid value
        for the property to have in order to be ignored. (NIL will always be ignored)

Returns:
    <NIL, ARRAY, NUMBER, or STRING> - The config value returned by the most specific config passed
        that is valid.

Examples:
    (begin example)
		private _valueFromMostSpecificClass = [
            "myProperty"
            [
                missionConfigFile >> "SomeClass",
                missionConfigFile >> "SomeClass" >> "SomeSubClass",
                missionConfigFile >> "SomeClass" >> "SomeSubClass" >> "SomeFurtherSubClass",
            ],
            "" // shouldn't be an empty string
        ] call KISKA_fnc_getMostSpecificCfgValue;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getMostSpecificCfgValue";

params [
    ["_property","",[""]],
    ["_configs",[],[[]]],
    ["_ignoredValue",0,[123,[],""]]
];

if (_property isEqualTo "") exitWith {
    ["_property is empty!",true] call KISKA_fnc_log;
    nil
};


private "_mostSpecificValue";
private _mostSpecificHierarchyCount = -1;
_configs apply {
    if !(_x isEqualType configNull) then {continue};
    if (isNull _x) then {continue};

    private _hierarchyCount = count (configHierarchy _x);
    if (_hierarchyCount <= _mostSpecificHierarchyCount) then {continue};

    private _propertyValue = (_x >> _property) call BIS_fnc_getCfgData;
    if ((isNil "_propertyValue") OR {_propertyValue isEqualTo _ignoredValue}) then {continue};

    _mostSpecificValue = _propertyValue;
    _mostSpecificHierarchyCount = _hierarchyCount;
};


_mostSpecificValue
