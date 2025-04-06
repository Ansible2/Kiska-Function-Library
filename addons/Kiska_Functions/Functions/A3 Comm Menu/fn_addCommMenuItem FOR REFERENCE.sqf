#define MAX_SUPPORTS 10

params [
    ["_unit",player,[objNull]],
    ["_class","",[""]],
    ["_argsText",[],[]],
    ["_argsExpression",[],[]],
    ["_notificationClass","CommunicationMenuItemAdded",[""]]
];

private _menu = _unit getvariable ["BIS_fnc_addCommMenuItem_menu",[]];
if ((count _menu) >= MAX_SUPPORTS) exitwith {
    [["Max number of supports (",MAX_SUPPORTS,") has been reached"],false] call KISKA_fnc_log; 
    -1
};

if !(_argsText isEqualType []) then { _argsText = [_argsText]; };
if !(_argsExpression isEqualType []) then { _argsExpression = [_argsExpression]; };

// TODO: do we even need this to be in a CfgCommunicationMenu class?
// TODO: ensure that the config is passed as an arg to the expression so we can get rid of support types
private _cfg = [["CfgCommunicationMenu",_class]] call KISKA_fnc_findConfigAny;
if (isNull _cfg) exitWith {
    [["Could not locate config for class ",_class],true] call KISKA_fnc_log;
    -1
};

private _text = format([getText(_cfg >> "text")] + _argsText)
private _submenu = getText(_cfg >> "submenu");
private _expression = format([getText(_cfg >> "expression")] + _argsExpression)
private _icon = getText(_cfg >> "icon");
private _iconText = getText(_cfg >> "iconText");
private _cursor = getText(_cfg >> "cursor");
private _enable = getText(_cfg >> "enable");
// TODO: use get bool function
private _removeAfterExpressionCall = getNumber (_cfg >> "removeAfterExpressionCall");

// TODO: these can probably be strings
private _itemID = ["BIS_fnc_addCommMenuItem_counter",1] call bis_fnc_counter;

// TODO: why check for duplicate ids?
//--- Terminate when the item is already in the menu
private _isDuplicate = false;
_menu apply {
	if ((_x select 0) == _itemID) then {
        _isDuplicate = true;
        break;
    };
};

if (_isDuplicate) exitwith {
    ["Class '%1' already registered in the communication menu",_class] call bis_fnc_error; -1
};

//--- Compose expression arguments
private _var = _unit call bis_fnc_objectVar;
// TODO: should be able to accept code as an input and just save it to 
// a global variable that is called with args
_expression = format ["_this = [%1,_pos,_target,_is3D,%2];",_var,_itemID] + _expression;


// TODO: this might be of further use to streamline how many rounds/uses a support has
// it probably shouldn't always be removed and added back if it has any more uses left
//--- Add a code to remove the item upon calling
if (_removeAfterExpressionCall > 0) then {
	_expression = format ["[%1,%2] call bis_fnc_removeCommMenuItem;",_var,_itemID] + _expression;
};

//--- Register the item
_menu set [
	count _menu,
	[
		_itemID,
		_text,
		_submenu,
		_expression,
		_enable,
		_cursor,
		_icon,
		_iconText
	]
];
_unit setvariable ["BIS_fnc_addCommMenuItem_menu",_menu];

// TODO: might not be necessary
//--- Execute constant loop for refreshing the menu when player object changed (e.g., upon team switch)
if (isnil "BIS_fnc_addCommMenuItem_loop") then {
	BIS_fnc_addCommMenuItem_loop = [] spawn {
		scriptname "BIS_fnc_addCommMenuItem_loop";
		_player = objnull;
		while {true} do {
			waituntil {
				sleep 0.1;
				player != _player
			};
			[] call KISKA_fnc_refreshCommMenu;
			_player = player;
		};
	};
};

// TODO: definitely unnecessary
//--- Restore the icons upon game load
if (isnil "BIS_fnc_addCommMenuItem_load") then {
	BIS_fnc_addCommMenuItem_load = addmissioneventhandler ["loaded",
	{
		[] spawn {sleep 1;[] call KISKA_fnc_refreshCommMenu;};
	}];
};

if (_unit == player) then {
	//--- Refresh the menu and icons
	[] call KISKA_fnc_refreshCommMenu;

	//--- Notify
	if (_notificationClass != "") then {
		[_notificationClass,[_text,_icon,_iconText]] call BIS_fnc_showNotification;
	};

	//--- Close the menu when opened
	if (commandingmenu == "#User:BIS_fnc_addCommMenuItem_menu") then {showcommandingmenu "";};
};

_itemID