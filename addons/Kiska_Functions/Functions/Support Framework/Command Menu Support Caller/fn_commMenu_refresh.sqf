// TODO: 
// get loop through all kiska supports finding those that are commMenu supports
// get the support's details for the comm menu (cache them against the support config)
// overwrite the BIS_fnc_addCommMenuItem_menu variable with the information as below
private _text = getText(_commMenuDetailsConfig >> "text");
private _onSupportSelected = getText(_commMenuDetailsConfig >> "onSupportSelected");
private _icon = getText(_commMenuDetailsConfig >> "icon");
private _iconText = getText(_commMenuDetailsConfig >> "iconText");
private _cursor = getText(_commMenuDetailsConfig >> "cursor");


/*
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
*/