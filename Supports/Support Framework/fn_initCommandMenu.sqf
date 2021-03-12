#include "Headers\CAS Type IDs.hpp"
#include "Headers\Command Menus.hpp"
#include "Headers\Arty Ammo Classes.hpp"
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
#define CHECK_MENU_NAME(MENU_NAME) _menuName == #MENU_NAME
#define CMD_EXECUTE -5
#define IS_ACTIVE "1"
#define IS_VISIBLE "1"
#define EXPRESSION(CODE) [["expression", CODE]]
#define KEY_SHORTCUT(KEY) [KEY]
#define SAVE_MENU missionNamespace setVariable [_menuName,_menuArray];
#define SAVE_AND_RETURN SAVE_MENU _menuArray
#define STD_LINE(TITLE,KEY,CODE) [TITLE, KEY_SHORTCUT(KEY), "", CMD_EXECUTE, EXPRESSION(CODE), IS_ACTIVE, IS_VISIBLE]
#define PUSHBACK_AND_PROCEED(VALUE) "(uiNamespace getVariable 'KISKA_commMenuTree_params') pushBack " + (str VALUE) + "; uiNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];"
#define DISTANCE_LINE(DIS,KEY) STD_LINE((str DIS) + "m",KEY,PUSHBACK_AND_PROCEED(DIS))

scriptName "KISKA_fnc_initCommandMenu";

if (!hasInterface) exitWith {};

params [
	["_menuName","",[""]]
];
private _menuArray = [];






/* ----------------------------------------------------------------------------
	Counts
---------------------------------------------------------------------------- */
#define COUNT_LINE(NUMBER,KEY) STD_LINE(str NUMBER,KEY,PUSHBACK_AND_PROCEED(NUMBER))
if (COUNT_TO_BASE in (toLowerANSI _menuName)) exitWith {
	private _stringIndexLength = (count _string) - 1;
	// get the number at the end of the menu name to denote the count
	private _numberOfEntries = [_string select [_stringIndexLength]] call BIS_fnc_parseNumberSafe;
	
	_menuArray = 
	[
		["Number Of Rounds",false]
	];

	for "_i" from 1 to _numberOfEntries do {
		// don't go above the number line keys (key codes 2-10)
		if (_i <= 9) then {
			_menuArray pushBack COUNT_LINE(_i,_i + 1);
		} else {
			_menuArray pushBack COUNT_LINE(_i,0);
		};
	};

	SAVE_AND_RETURN
};


/* ----------------------------------------------------------------------------
	Radius
---------------------------------------------------------------------------- */
if (CHECK_MENU_NAME(RADIUS_MENU)) exitWith {
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
		DISTANCE_LINE(500,9)
	];

	SAVE_AND_RETURN
};

/* ----------------------------------------------------------------------------
	Bearings
---------------------------------------------------------------------------- */
#define BEARING_LINE(BEARING,DIR,KEY) STD_LINE((str BEARING) + DIR,KEY,PUSHBACK_AND_PROCEED(BEARING))
if (CHECK_MENU_NAME(BEARING_MENU)) exitWith {
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
if (CHECK_MENU_NAME(FLYIN_MENU)) exitWith {
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
if (CHECK_MENU_NAME(CAS_TYPES_ALL_MENU)) exitWith {
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
if (CHECK_MENU_NAME(CAS_TYPES_GUNSANDROCKETS_MENU)) exitWith {
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
if (CHECK_MENU_NAME(CAS_TYPES_ROCKETS_MENU)) exitWith {
	_menuArray = 
	[
		["CAS Type", false],
		STD_LINE("Rockets (AP)",2,PUSHBACK_AND_PROCEED(ROCKETS_ARMOR_PIERCING_ID)),
		STD_LINE("Rockets (HE)",3,PUSHBACK_AND_PROCEED(ROCKETS_HE_ID))
	];

	SAVE_AND_RETURN
};

// Bombs
if (CHECK_MENU_NAME(CAS_TYPES_BOMBS_MENU)) exitWith {
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
if (CHECK_MENU_NAME(AMMO_120_MENU)) exitWith {
	_menuArray = 
	[
		["120mm Ammo Type", false],
		STD_LINE("120mm AT Mines",2,PUSHBACK_AND_PROCEED(AMMO_120_ATMINES_CLASS)),
		STD_LINE("120mm Cluster",3,PUSHBACK_AND_PROCEED(AMMO_120_CLUSTER_CLASS)),
		STD_LINE("120mm HE",4,PUSHBACK_AND_PROCEED(AMMO_120_HE_CLASS)),		
		STD_LINE("120mm Mines",5,PUSHBACK_AND_PROCEED(AMMO_120_MINES_CLASS)),
		STD_LINE("120mm Smoke",6,PUSHBACK_AND_PROCEED(AMMO_120_SMOKE_CLASS))
	];

	SAVE_AND_RETURN
};

// 155
if (CHECK_MENU_NAME(AMMO_155_MENU)) exitWith {
	_menuArray = 
	[
		["155mm Ammo Type", false],
		STD_LINE("155mm AT Mines",2,PUSHBACK_AND_PROCEED(AMMO_155_ATMINES_CLASS)),
		STD_LINE("155mm Cluster",3,PUSHBACK_AND_PROCEED(AMMO_155_CLUSTER_CLASS)),	
		STD_LINE("155mm HE",4,PUSHBACK_AND_PROCEED(AMMO_155_HE_CLASS)),
		STD_LINE("155mm Mines",5,PUSHBACK_AND_PROCEED(AMMO_155_MINES_CLASS))
	];

	SAVE_AND_RETURN
};

// 82
if (CHECK_MENU_NAME(AMMO_82_MENU)) exitWith {
	_menuArray = 
	[
		["82mm Ammo Type", false],
		STD_LINE("82mm HE",2,PUSHBACK_AND_PROCEED(AMMO_82_HE_CLASS)),
		STD_LINE("82mm Smoke (White)",3,PUSHBACK_AND_PROCEED(AMMO_82_SMOKE_CLASS)),	
		STD_LINE("82mm Flare",4,PUSHBACK_AND_PROCEED(AMMO_82_FLARE_CLASS))	
	];

	SAVE_AND_RETURN
};





[["Could not find any menu presets for: ",_menuName],true] call KISKA_fnc_log;
[]