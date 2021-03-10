/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commandMenuTree

Description:
	Creates a command menu tree dynamically instead of needing to define sub menus

Parameters:
	0: _menuPath <ARRAY> - The menu global variable paths (in order)
	1: _endExpression <STRING or CODE> - The code to be executed at the end of the path
	2: _exitExpression <STRING or CODE> - The code to be executed in the event that the menu is closed by the player
	3: _args <ARRAY> - Arguements to pass to the script/expression

Returns:
	NOTHING

Examples:
    (begin example)
		[
			["menu1","menu2"],
			"hint str _this"
		] call KISKA_fnc_commandMenuTree
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define COMMAND_MENU_CLOSED commandingMenu isEqualTo ""

scriptName "KISKA_fnc_commandMenuTree";

if (!hasInterface) exitWith {
	["Can only run on machines with interface",false] call KISKA_fnc_log;
	nil
};

if (!canSuspend) exitWith {
	["Must be run in scheduled, exiting to scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_commandMenuTree
};

params [
	["_menuPath",[],[[]]],
	["_endExpression","",["",{}]],
	["_exitExpression","",["",{}]],
	["_args",[],[[]]]
];


// create a container for holding params from menu
uiNamespace setVariable ["KISKA_commMenuTree_params",[]];

private _menuClosed = false;
_menuPath apply {
	// keeps track of whether or not to open the next menu
	uiNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",false]; 
	showCommandingMenu _x;

	// wait for menu to allow proceed or menu is closed
	waitUntil {
		if (uiNamespace getVariable "KISKA_commMenuTree_proceedToNextMenu") exitWith {true};
		if (COMMAND_MENU_CLOSED) exitWith {
			hint "menu closed";
			_menuClosed = true;
			true
		};
		sleep 0.5;
		false
	};
	if (_menuClosed) exitWith {};
};


if (!_menuClosed) then {
	private _params = uiNamespace getVariable "KISKA_commMenuTree_params";
	_params call (compile _endExpression);
} else {

};

uiNamespace setVariable ["KISKA_commMenuTree_params",nil];
uiNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",nil];