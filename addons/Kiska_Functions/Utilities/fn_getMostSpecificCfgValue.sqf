/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getMostSpecificCfgValue

Description:
	Picks the most specific value from a list of configs properties to check.

Parameters:
    0: _property <STRING> - The config property to search for in all of the classes
    1: _configs <ARRAY> - An array of CONFIGs that you would like to look for the
        property. These should be within the same configHierarchy.
    2: _ignoredValues <ARRAY of ARRAY, NUMBER, or STRING> - A list of invalid values
        for the property to have in order to be ignored. (strings should be lowercase)
        (NIL will always be ignored)
    3: _ignoredTypes <ARRAY of ARRAY, NUMBER, or STRING> - A list of invalid types for the property

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
            [""], // shouldn't be an empty string,
            [123] // ignore number properties
        ] call KISKA_fnc_getMostSpecificCfgValue;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getMostSpecificCfgValue";

params [
    ["_property","",[""]],
    ["_configs",[],[[]]],
    ["_ignoredValues",0,[123,[],""]],
    ["_ignoredTypes",[],[[]]]
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
    if (
        isNil "_propertyValue" OR
        {_propertyValue isEqualTypeAny _ignoredTypes}
    ) then {continue};

    private _propertyValueCompare = _propertyValue;
    if (_propertyValueCompare isEqualType "") then {
        _propertyValueCompare = toLower _propertyValueCompare
    };
    if (_propertyValueCompare in _ignoredValues) then {continue};

    _mostSpecificValue = _propertyValue;
    _mostSpecificHierarchyCount = _hierarchyCount;
};


_mostSpecificValue
