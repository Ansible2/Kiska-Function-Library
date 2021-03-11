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
		_initializedMenu = ["KISKA_commandMenu_radius"] call KISKA_fnc_initCommandMenu
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
#define DISTANCE_LINE(DIS,KEY) STD_LINE(#DIS + "m",KEY,PUSHBACK_AND_PROCEED(DIS))

scriptName "KISKA_fnc_initCommandMenu";

if (!hasInterface) exitWith {};

params [
	["_menuName","",[""]]
];
private _menuArray = [];


/* ----------------------------------------------------------------------------
	Radius
---------------------------------------------------------------------------- */
if (CHECK_MENU_NAME("KISKA_commandMenu_radius")) exitWith {
	_menuArray = 
	[
		["Radius", false],
		DISTANCE_LINE(25,2),
		DISTANCE_LINE(50,3),
		DISTANCE_LINE(100,4),
		DISTANCE_LINE(175,5),
		DISTANCE_LINE(250,6),
		DISTANCE_LINE(350,7),
		DISTANCE_LINE(400,8),
		DISTANCE_LINE(500,9),
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
	flyInHeight
---------------------------------------------------------------------------- */
#define FLYIN_LINE()
if (CHECK_MENU_NAME("KISKA_commandMenu_flyInHeight")) exitWith {
	_menuArray =
	[
		["Fly In Height", false],
		DISTANCE_LINE(10,2),
		DISTANCE_LINE(25,3),
		DISTANCE_LINE(50,4),
		DISTANCE_LINE(100,5),
		DISTANCE_LINE(150,6),
		DISTANCE_LINE(200,7),
		DISTANCE_LINE(250,8)
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

/* ----------------------------------------------------------------------------
	Artillery
---------------------------------------------------------------------------- */
// 120
if (CHECK_MENU_NAME("KISKA_commandMenu_artyAmmo_120")) exitWith {
	_menuArray = 
	[
		["120mm Ammo Type", false],
		STD_LINE("120mm AT Mines",2,PUSHBACK_AND_PROCEED("ammo_ShipCannon_120mm_AT_mine")),
		STD_LINE("120mm Cluster",3,PUSHBACK_AND_PROCEED("ammo_ShipCannon_120mm_HE_cluster")),
		STD_LINE("120mm HE",4,PUSHBACK_AND_PROCEED("ammo_ShipCannon_120mm_HE")),		
		STD_LINE("120mm Mines",5,PUSHBACK_AND_PROCEED("ammo_ShipCannon_120mm_mine")),
		STD_LINE("120mm Smoke",6,PUSHBACK_AND_PROCEED("ammo_ShipCannon_120mm_smoke"))
	];

	SAVE_AND_RETURN
};

// 155
if (CHECK_MENU_NAME("KISKA_commandMenu_artyAmmo_155")) exitWith {
	_menuArray = 
	[
		["155mm Ammo Type", false],
		STD_LINE("155mm AT Mines",2,PUSHBACK_AND_PROCEED("AT_Mine_155mm_AMOS_range")),
		STD_LINE("155mm Cluster",3,PUSHBACK_AND_PROCEED("Cluster_155mm_AMOS")),	
		STD_LINE("155mm HE",4,PUSHBACK_AND_PROCEED("Sh_155mm_AMOS")),
		STD_LINE("155mm Mines",5,PUSHBACK_AND_PROCEED("Mine_155mm_AMOS_range"))
	];

	SAVE_AND_RETURN
};

// 82
if (CHECK_MENU_NAME("KISKA_commandMenu_artyAmmo_82")) exitWith {
	_menuArray = 
	[
		["82mm Ammo Type", false],
		STD_LINE("82mm HE",2,PUSHBACK_AND_PROCEED("Sh_82mm_AMOS")),
		STD_LINE("82mm Smoke (White)",3,PUSHBACK_AND_PROCEED("Smoke_82mm_AMOS_White")),	
		STD_LINE("82mm Flare",4,PUSHBACK_AND_PROCEED("F_20mm_white"))	
	];

	SAVE_AND_RETURN
};


[["Could not find any menu presets for: ",_menuName],true] call KISKA_fnc_log;
[]