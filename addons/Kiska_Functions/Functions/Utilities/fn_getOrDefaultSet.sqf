/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getOrDefaultSet

Description:
    Gets a namespace variable or calls the provided code that will set the default
    value.

Parameters:
    0: _namespace <NAMESPACE> - Anything that supports `getVariable` and `setVariable`.
    1: _variableName <STRING> - The name of the variable to get and/or set.
    2: _getDefault <CODE, STRING, or ARRAY> - Code that must return the default value of the variable.
        Will only be called in the event that the provided variable `isNil`. See `KISKA_fnc_callBack`

Returns:
    <ANY> - The value of the variable

Examples:
    (begin example)
        private _value = [
            localNamespace,
            "MyVariable",
            {[]} // set "MyVariable" in localNamespace to [] if it does not exist
        ] call KISKA_fnc_getOrDefaultSet;
    (end)

    (begin example)
        // _value == "MyString"
        private _value = [
            localNamespace,
            "MyVariable",
            [["MyString"],{ _thisArgs select 0 }]
        ] call KISKA_fnc_getOrDefaultSet;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getOrDefaultSet";

params [
    ["_namespace",missionNamespace,[missionNamespace,objNull,locationNull,grpNull,teamMemberNull,taskNull,controlNull,displayNull]],
    ["_variableName","",[""]],
    ["_getDefault",{},[{},"",[]]]
];

private _value = _namespace getVariable _variableName;
if !(isNil "_value") exitWith {_value};

_value = [[],_getDefault,false] call KISKA_fnc_callBack;
_namespace setVariable [_variableName,_value];


_value
