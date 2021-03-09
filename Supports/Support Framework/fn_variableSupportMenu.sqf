/* ----------------------------------------------------------------------------
Function: KISKA_fnc_variableSupportMenu

Description:
	Creates a command menu tree

Parameters:
	0: _menuPath <ARRAY> - The menu global variable paths (in order)
	1: _endExpression <STRING> - The code to be executed at the end of the path
	2: _menuID <NUMBER> - The communication menu id so the support can be removed upon call

Returns:
	NOTHING

Examples:
    (begin example)
		[
			["menu1","menu2"],
			"[KISKA_supportMenu_hash get] call myFunction;"
		] call KISKA_fnc_variableSupportMenu
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define COMMAND_MENU_CLOSED commandingMenu isEqualTo ""

scriptName "KISKA_fnc_variableSupportMenu";

if (!hasInterface) exitWith {
	["Can only run on machines with interface",false] call KISKA_fnc_log;
	nil
};

if (!canSuspend) exitWith {
	["Must be run in scheduled, exiting to scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_variableSupportMenu
};

params [
	["_menuPath",[],[[]]],
	["_endExpression","",["",{}]],
	["_menuID",-1,[123]]
];




// create a container for holding params from menu
uiNamespace setVariable ["KISKA_variableSupportMenu_params",[]];

private _menuClosed = false;
_menuPath apply {
	// keeps track of whether or not to open the next menu
	uiNamespace setVariable ["KISKA_variableSupportMenu_proceedToNextMenu",false]; 
	showCommandingMenu _x;

	// wait for menu to allow proceed or menu is closed
	waitUntil {
		if (uiNamespace getVariable "KISKA_variableSupportMenu_proceedToNextMenu") exitWith {true};
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
	private _params = uiNamespace getVariable "KISKA_variableSupportMenu_params";
	_params call (compile _endExpression);
	[player,_menuID] call BIS_fnc_removeCommMenuItem;
};

uiNamespace setVariable ["KISKA_variableSupportMenu_params",nil];
uiNamespace setVariable ["KISKA_variableSupportMenu_proceedToNextMenu",nil];