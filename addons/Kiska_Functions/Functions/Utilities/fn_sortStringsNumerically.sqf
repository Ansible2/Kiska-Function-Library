/* ----------------------------------------------------------------------------
Function: KISKA_fnc_sortStringsNumerically

Description:
    Takes an array or strings, where each string must end with an underscore and a digit
     (`"something_1"`) and can handle one extra sub level digit (`"something_1_1"`).

Parameters:
    0: _strings <STRING[]> - Default: `[]` - The strings you would like to sort
    1: _order <BOOLEAN> - Default: `true` - ascending (`true`) or descending (`false`) 

Returns:
    <STRING[]> - The sorted list of strings

Examples:
    (begin example)
        [
            ["myString_2","myString_3","myString_1_1","myString_1"]
        ] call KISKA_fnc_sortStringsNumerically;
        // returns -> `["myString_1","myString_1_1","myString_2","myString_3"]`
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_sortStringsNumerically";

params [
    ["_strings",[],[[]]],
    ["_order",true,[true]]
];

private _sortKeyMap = createHashMap;
{
    private _regexMatches = (_x regexFind ["_(\d+)_*(\d*)"]) param [0,[]];
    _regexMatches params ["","_mainNumberMatch","_subNumberMatch"];
    private _mainIndex = _mainNumberMatch select 0;
    private _sortString = _mainIndex;

    private _subIndex = _subNumberMatch select 0;
    if (_subIndex isNotEqualTo "") then {
        _sortString = [_sortString,_subIndex] joinString ".";
    };

    _sortKeyMap set [_sortString,_x];
} forEach _strings;

private _sortedKeys = keys _sortKeyMap;
_sortedKeys sort _order;


_sortedKeys apply { _sortKeyMap get _x }
