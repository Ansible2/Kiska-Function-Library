/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_refresh

Description:
    Redefines the global `BIS_fnc_addCommMenuItem_menu` array with all the player's
    current comm menu supports.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_commMenu_refresh;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_refresh";

private _selectionMenu = [
    [localize "STR_rscMenu.hppRscGroupRootMenu_Items_Communication0",true]
];
private _playerMenu = [];

private _idToDetailsMap = [
    localNamespace,
    "KISKA_commMenu_supportIdToDetailsMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
{
    _y params [
        "",
        "_text",
        "_submenu",
        "_commMenuExpression",
        "_enableExpression",
        "_cursor",
        "_icon",
        "_iconText"
    ];
    private _keyboardShortcutKey = _foreachindex + 2;
    _selectionMenu pushBack [_text,[_keyboardShortcutKey],_submenu,-5,[["expression",_commMenuExpression]],"1",_enableExpression,_cursor];
    _playerMenu pushBack [
        _forEachIndex,
        _text,
        _submenu,
        _commMenuExpression,
        _enableExpression,
        _cursor,
        _icon,
        _iconText
    ];
} foreach _idToDetailsMap;

missionnamespace setvariable ["BIS_fnc_addCommMenuItem_menu", _selectionMenu];
// used in \A3\Ui_f\scripts\IGUI\RscCommMenuItems.sqf
player setvariable ["BIS_fnc_addCommMenuItem_menu",_playerMenu];
("BIS_fnc_addCommMenuItem" call bis_fnc_rscLayer) cutrsc ["RscCommMenuItems","plain"];


nil
