/* ----------------------------------------------------------------------------
Function: KISKA_fnc_initCommandMenu

Description:
	Loads a given preset value in the configuration used by the command showCommandingMenu.
	This will be saved as a missionNamespace global var.

Parameters:
	0: _menuName : <STRING> - The name of the menu preset

Returns:
	<BOOL> - True if global menu loaded loaded

Examples:
    (begin example)
		_didInit = [] call KISKA_fnc_initCommandMenu
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define CHECK_MENU_NAME(MENU_NAME) _menuName == MENU_NAME
#define CMD_EXECUTE -5
#define IS_ACTIVE "1"
#define IS_VISIBLE "1"
#define EXPRESSION(CODE) [["expression", CODE]]
#define KEY_SHORTCUT(KEY) [KEY]
#define SAVE_MENU missionNamespace setVariable [_menuName,_menuCfg];
#define SAVE_AND_RETURN SAVE_MENU true
#define STD_LINE(TITLE,KEY,CODE) [TITLE, KEY_SHORTCUT(KEY), "", CMD_EXECUTE, EXPRESSION(CODE), IS_ACTIVE, IS_VISIBLE]
#define PUSHBACK_AND_PROCEED(VALUE) "(uiNamespace getVariable 'KISKA_commMenuTree_params') pushBack " + (str VALUE) + "; uiNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];"

scriptName "KISKA_fnc_initMenu";

if (!hasInterface) exitWith {};

params [
	["_menuName","",[""]]
];
private _menuCfg = [];


if (CHECK_MENU_NAME("KISKA_menu_test")) exitWith {
	_menuCfg = 
	[
		["KISKA Test Menu", false],
		STD_LINE("Option 1",2,PUSHBACK_AND_PROCEED("Numba 1")),
		STD_LINE("Option 2",3,PUSHBACK_AND_PROCEED(3))
	];

	SAVE_AND_RETURN
};





[["Could not find any menu presets for: ",_menuName],true] call KISKA_fnc_log;
false