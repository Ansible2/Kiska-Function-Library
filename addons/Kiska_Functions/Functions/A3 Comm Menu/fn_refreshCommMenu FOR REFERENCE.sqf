/*
	Author: Karel Moricky
*/

private _menu = player getvariable ["BIS_fnc_addCommMenuItem_menu",[]];
private _menuIndexed = [
    [localize "STR_rscMenu.hppRscGroupRootMenu_Items_Communication0",true]
];

{
    _x params [
        "", // _itemID
        "_text",
        "_submenu",
        "_expression",
        "_enable",
        "_cursor",
        "_icon"
    ];
    private _assignedKey = _foreachindex + 2;
	_menuIndexed pushBack [_text,[_assignedKey],_submenu,-5,[["expression",_expression]],"1",_enable,_cursor];
} foreach _menu;


missionnamespace setvariable
[
	"BIS_fnc_addCommMenuItem_menu",
	_menuIndexed
];

("BIS_fnc_addCommMenuItem" call bis_fnc_rscLayer) cutrsc ["RscCommMenuItems","plain"];

true