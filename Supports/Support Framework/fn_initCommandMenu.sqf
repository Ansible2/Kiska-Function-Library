#include "Headers\CAS Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_initCommandMenu

Description:
	Loads a given preset value in the configuration used by the command showCommandingMenu.
	This will be saved as a missionNamespace global var.

Parameters:
	0: _menuName : <STRING> - The name of the menu preset

Returns:
	<ARRAY> - The intialized array

Examples:
    (begin example)
		_initializedMenu = [] call KISKA_fnc_initCommandMenu
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
#define SAVE_MENU missionNamespace setVariable [_menuName,_menuArray];
#define SAVE_AND_RETURN SAVE_MENU _menuArray
#define STD_LINE(TITLE,KEY,CODE) [TITLE, KEY_SHORTCUT(KEY), "", CMD_EXECUTE, EXPRESSION(CODE), IS_ACTIVE, IS_VISIBLE]
#define PUSHBACK_AND_PROCEED(VALUE) "(uiNamespace getVariable 'KISKA_commMenuTree_params') pushBack " + (str VALUE) + "; uiNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];"

scriptName "KISKA_fnc_initMenu";

if (!hasInterface) exitWith {};

params [
	["_menuName","",[""]]
];
private _menuArray = [];


if (CHECK_MENU_NAME("KISKA_menu_test")) exitWith {
	_menuArray = 
	[
		["KISKA Test Menu", false],
		STD_LINE("Option 1",2,PUSHBACK_AND_PROCEED("Numba 1")),
		STD_LINE("Option 2",3,PUSHBACK_AND_PROCEED(3))
	];

	SAVE_AND_RETURN
};

/* ----------------------------------------------------------------------------
	Radius
---------------------------------------------------------------------------- */
if (CHECK_MENU_NAME("KISKA_commandMenu_radius")) exitWith {
	_menuArray = 
	[
		["Radius Selection", false],
		STD_LINE("25m",2,PUSHBACK_AND_PROCEED(25)),
		STD_LINE("50m",3,PUSHBACK_AND_PROCEED(50)),
		//STD_LINE("75m",4,PUSHBACK_AND_PROCEED(75)),
		STD_LINE("100m",4,PUSHBACK_AND_PROCEED(100)),
		//STD_LINE("150m",6,PUSHBACK_AND_PROCEED(150)),
		//STD_LINE("200m",5,PUSHBACK_AND_PROCEED(200)),
		STD_LINE("250m",5,PUSHBACK_AND_PROCEED(250)),
		STD_LINE("400m",6,PUSHBACK_AND_PROCEED(400)),
		STD_LINE("500m",7,PUSHBACK_AND_PROCEED(500))
	];

	SAVE_AND_RETURN
};

/* ----------------------------------------------------------------------------
	Bearings
---------------------------------------------------------------------------- */
#define BEARING_LINE(BEARING,DIR,KEY) STD_LINE(#BEARING + DIR,KEY,PUSHBACK_AND_PROCEED(BEARING))
if (CHECK_MENU_NAME("KISKA_commandMenu_bearing")) exitWith {
	_menuArray = 
	[
		["Approach Bearing", false],
		BEARING_LINE(0,"N",2),
		BEARING_LINE(45,"NE",3),
		BEARING_LINE(90,"E",4),
		BEARING_LINE(135,"SE",5),
		BEARING_LINE(180,"S",6),
		BEARING_LINE(225,"SW",7),
		BEARING_LINE(270,"W",8),
		BEARING_LINE(315,"NW",9)
	];

	SAVE_AND_RETURN
};

/* ----------------------------------------------------------------------------
	CAS Types
---------------------------------------------------------------------------- */
// all
if (CHECK_MENU_NAME("KISKA_commandMenu_casTypes_all")) exitWith {
	_menuArray = 
	[
		["CAS Type", false],
		STD_LINE("Gun Run",2,PUSHBACK_AND_PROCEED(GUN_RUN_ID)),
		STD_LINE("Guns & Rockets (AP)",3,PUSHBACK_AND_PROCEED(GUNS_AND_ROCKETS_ARMOR_PIERCING_ID)),
		STD_LINE("Guns & Rockets (HE)",4,PUSHBACK_AND_PROCEED(GUNS_AND_ROCKETS_HE_ID)),
		STD_LINE("Rockets (AP)",5,PUSHBACK_AND_PROCEED(ROCKETS_ARMOR_PIERCING_ID)),
		STD_LINE("Rockets (HE)",6,PUSHBACK_AND_PROCEED(ROCKETS_HE_ID)),
		STD_LINE("AGM",7,PUSHBACK_AND_PROCEED(AGM_ID)),
		STD_LINE("Bomb (Unguided)",8,PUSHBACK_AND_PROCEED(BOMB_UGB_ID)),
		STD_LINE("Cluster Bomb",9,PUSHBACK_AND_PROCEED(BOMB_CLUSTER_ID))
	];

	SAVE_AND_RETURN
};

// guns and rockets
if (CHECK_MENU_NAME("KISKA_commandMenu_casTypes_gunsrockets")) exitWith {
	_menuArray = 
	[
		["CAS Type", false],
		STD_LINE("Gun Run",2,PUSHBACK_AND_PROCEED(GUN_RUN_ID)),
		STD_LINE("Guns & Rockets (AP)",3,PUSHBACK_AND_PROCEED(GUNS_AND_ROCKETS_ARMOR_PIERCING_ID)),
		STD_LINE("Guns & Rockets (HE)",4,PUSHBACK_AND_PROCEED(GUNS_AND_ROCKETS_HE_ID)),
		STD_LINE("Rockets (AP)",5,PUSHBACK_AND_PROCEED(ROCKETS_ARMOR_PIERCING_ID)),
		STD_LINE("Rockets (HE)",6,PUSHBACK_AND_PROCEED(ROCKETS_HE_ID))
	];

	SAVE_AND_RETURN
};

// rockets
if (CHECK_MENU_NAME("KISKA_commandMenu_casTypes_rockets")) exitWith {
	_menuArray = 
	[
		["CAS Type", false],
		STD_LINE("Rockets (AP)",2,PUSHBACK_AND_PROCEED(ROCKETS_ARMOR_PIERCING_ID)),
		STD_LINE("Rockets (HE)",3,PUSHBACK_AND_PROCEED(ROCKETS_HE_ID))
	];

	SAVE_AND_RETURN
};

// Bombs
if (CHECK_MENU_NAME("KISKA_commandMenu_casTypes_bombs")) exitWith {
	_menuArray = 
	[
		["CAS Type", false],
		STD_LINE("AGM",2,PUSHBACK_AND_PROCEED(AGM_ID)),
		STD_LINE("Bomb (Unguided)",3,PUSHBACK_AND_PROCEED(BOMB_UGB_ID)),
		STD_LINE("Cluster Bomb",4,PUSHBACK_AND_PROCEED(BOMB_CLUSTER_ID))
	];

	SAVE_AND_RETURN
};



[["Could not find any menu presets for: ",_menuName],true] call KISKA_fnc_log;
false