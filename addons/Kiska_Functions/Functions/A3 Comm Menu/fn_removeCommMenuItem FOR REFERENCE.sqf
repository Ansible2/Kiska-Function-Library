private ["_unit","_itemID","_itemFound","_menu","_xID"];

params [
    // is there any point in assuming anyone other than the player will be taking these supports?
    ["_unit",player,[objNull]],
    ["_itemID",-1,[123]],
    ["_itemFound",false,[false]]
];



private _menu = _unit getvariable ["BIS_fnc_addCommMenuItem_menu",[]];
{
	private _xID = _x select 0;
	if (_xID == _itemID) exitwith {
        _menu set [_foreachindex,-1]; _itemFound = true;
    };
} foreach _menu;
_menu = _menu - [-1];

if (_itemFound) then {
	_unit setvariable ["BIS_fnc_addCommMenuItem_menu",_menu];
	[] call bis_fnc_refreshCommMenu;

	if (count _menu == 0) then {
		terminate BIS_fnc_addCommMenuItem_loop;
		removemissioneventhandler ["loaded",BIS_fnc_addCommMenuItem_load];

		BIS_fnc_addCommMenuItem_loop = nil;
		BIS_fnc_addCommMenuItem_load = nil;
	};
	true
} else {
	["[x] Item %1 not found in the comm menu.",_itemID] call bis_fnc_error;
	false
};