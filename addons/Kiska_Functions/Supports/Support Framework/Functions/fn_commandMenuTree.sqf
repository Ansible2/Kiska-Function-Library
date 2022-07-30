/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commandMenuTree

Description:
	Creates a command menu tree dynamically instead of needing to define sub menus

Parameters:
	0: _menuPath <ARRAY> - The menu global variable paths (in order)
	1: _endExpression <STRING or CODE> - The code to be executed at the end of the path.
		It receives all menu parameters in _this.
	2: _args <ARRAY> - Arguements to be available to _endExpression & _exitExpression
	3: _exitExpression <STRING or CODE> - The code to be executed in the event that
		the menu is closed by the player. It gets all added params up to that point in _this

Returns:
	NOTHING

Examples:
    (begin example)
		[
			["#USER:myMenu_1","#USER:myMenu_2"],
			"hint str _this"
		] spawn KISKA_fnc_commandMenuTree
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
#define COMMAND_MENU_CLOSED commandingMenu isEqualTo ""

scriptName "KISKA_fnc_commandMenuTree";

if (!hasInterface) exitWith {
	["Can only run on machines with interface",false] call KISKA_fnc_log;
	nil
};

if (!canSuspend) exitWith {
	["Must be run in scheduled, exiting to scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_commandMenuTree;
};

params [
	["_menuPath",[],[[]]],
	["_endExpression","",["",{}]],
	["_args",[],[[]]],
	["_exitExpression","",["",{}]]
];

// create a container for holding params from menu
localNamespace setVariable ["KISKA_commMenuTree_params",[]];

private _menuClosed = false;
_menuPath apply {
	// proceed immediatetly if only one option is in custom menu
	private _menuName = toLower _x;

	// #user: prepended on the menu name denotes a custom menu
	// The menu options are saved to a global variable in the missionNamespace
	/// that is the menu's name, minus the ""#user:"
	/// e.g. a menu with the name "#USER:MY_SUBMENU_inCommunication" would be
	/// saved to a global variable MY_SUBMENU_inCommunication
	_menuName = _menuName trim ["#user:",1];
	if (_menuName != _x) then {
		private _menuOptions = missionNamespace getVariable [_menuName,[]];
		// _menuOptions will include the title at the start of the array, therefore, multiple actual options means at least 3 entries
		if (count _menuOptions < 3) then {
			// format of an option
			// ["Submenu", [3], "#USER:MY_SUBMENU_inCommunication", -5, [["expression", "player sidechat ""Submenu"" "]], "1", "1"]
			private _singleMenuOption = _menuOptions select 1;
			private _expression = ((_singleMenuOption select 4) select 0) select 1;
			[] call (compile _expression);

			continue;
		};
	};

	// keeps track of whether or not to open the next menu
	localNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",false];
	showCommandingMenu _x;

	// wait for player to select and option from the current menu or for them to close the menu
	waitUntil {
		if (localNamespace getVariable "KISKA_commMenuTree_proceedToNextMenu") exitWith {true};
		if (COMMAND_MENU_CLOSED) exitWith {
			_menuClosed = true;
			true
		};
		false
	};
	if (_menuClosed) then {
		break;
	};
};

private _params = localNamespace getVariable "KISKA_commMenuTree_params";
if (!_menuClosed) then {
	if (_endExpression isEqualType "") then {
		_endExpression = compile _endExpression;
	};

	_params call _endExpression;

} else {
	if (_exitExpression isEqualType "") then {
		_exitExpression = compile _exitExpression;
	};

	_params call _exitExpression;

};

localNamespace setVariable ["KISKA_commMenuTree_params",nil];
localNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",nil];
