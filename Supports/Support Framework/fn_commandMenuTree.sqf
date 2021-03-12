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
	_this spawn KISKA_fnc_commandMenuTree;
};

params [
	["_menuPath",[],[[]]],
	["_endExpression","",["",{}]],
	["_args",[],[[]]],
	["_exitExpression","",["",{}]]
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
			_menuClosed = true;
			true
		};
		sleep 0.1;
		false
	};
	if (_menuClosed) exitWith {};
};

private _params = uiNamespace getVariable "KISKA_commMenuTree_params";
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

uiNamespace setVariable ["KISKA_commMenuTree_params",nil];
uiNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",nil];