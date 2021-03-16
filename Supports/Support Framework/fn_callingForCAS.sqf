#include "Headers\Arty Ammo Classes.hpp"
#include "Headers\Command Menu Macros.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForCAS

Description:
	Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.
	
	This is essentially just another level of abrstraction to be able to more easily reuse
	 code between similar supports and make things easier to read instead of fitting it all
	 in the config.

Parameters:
	0: _commMenuArgs <ARRAY> - The arguements passed by comm menu
		0: _caller <OBJECT> - The player calling for support
		1: _targetPosition <ARRAY> - The position (AGLS) at which the call is being made 
			(where the player is looking or if in the map, the position where their cursor is)
		2: _target <OBJECT> - The cursorTarget object of the player
		3: _is3d <BOOL> - False if in map, true if not
		4: _commMenuId <NUMBER> The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
	1: _supportClass <STRING> - The config path as defined in the CfgCommunicationMenu
	2: _useCount <NUMBER> - Number of uses in the support left, if < 2, one use is allowed

Returns:
	NOTHING

Examples:
    (begin example)
		[] call KISKA_fnc_callingForCAS;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForCAS";

#define BEARING_LINE(BEARING,DIR,KEY) STD_LINE((str BEARING) + DIR,KEY,PUSHBACK_AND_PROCEED(BEARING))
#define MIN_RADIUS 200
#define VEHICLE_SELECT_MENU "KISKA_vehicleSelect_menu"
#define ATTACK_TYPE_MENU "KISKA_attackType_menu"
#define BEARING_MENU "KISKA_bearing_menu"


params [
	"_commMenuArgs",
	"_supportClass",
	"_useCount"
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
if (isNull _supportConfig) exitWith {
	[["Could not find class: ",_supportClass," in any config!"],true] call KISKA_fnc_log;
	nil
};


private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done


/* ----------------------------------------------------------------------------
	Vehicle Select Menu
---------------------------------------------------------------------------- */
private _vehicles = [_supportConfig >> "aircraftTypes"] call BIS_fnc_getCfgDataArray;
if (_vehicles isEqualTo []) then {
	side (_commMenuArgs select 0)
	// get CBA settings
};
private _vehicleMenu = [_vehicles] call KISKA_fnc_createVehicleSelectMenu;
SAVE_AND_PUSH(VEHICLE_SELECT_MENU,_vehicleMenu)


/* ----------------------------------------------------------------------------
	Attack Type Menu
---------------------------------------------------------------------------- */
private _attackTypeMenu = [
	["Attack Type",false]
];
// get allowed ammo types from config
private _attackTypes = [_supportConfig >> "attackTypes"] call BIS_fnc_getCfgDataArray;

// create formatted array to use in menu
private ["_casTitle","_keyCode"];
{
	if (_forEachIndex <= MAX_KEYS) then {
		// key codes are offset by 2 (1 on the number bar is key code 2)
		_keyCode = _forEachIndex + 2;
	} else {
		_keyCode = 0;
	};
	_casTitle = [_x] call KISKA_fnc_getCasTitleFromId;

	_attackTypeMenu pushBack STD_LINE_PUSH(_casTitle,_keyCode,_x);
} forEach _attackTypes;

SAVE_AND_PUSH(ATTACK_TYPE_MENU,_attackTypeMenu)


/* ----------------------------------------------------------------------------
	Bearings Menu
---------------------------------------------------------------------------- */
_bearingsMenu = 
[
	["Approach Bearing", false],
	BEARING_LINE(0," - N",2),
	BEARING_LINE(45," - NE",3),
	BEARING_LINE(90," - E",4),
	BEARING_LINE(135," - SE",5),
	BEARING_LINE(180," - S",6),
	BEARING_LINE(225," - SW",7),
	BEARING_LINE(270," - W",8),
	BEARING_LINE(315," - NW",9)
];

SAVE_AND_PUSH(BEARING_MENU,_bearingsMenu)


/* ----------------------------------------------------------------------------
	Create Menu
---------------------------------------------------------------------------- */
private _params = _this; // just for readability
_params pushBack _menuVariables;


[
	_menuPathArray,
	{
		params ["_vehicleClass","_attackType","_approachBearing"];

		private _targetPosition = (_args select 0) select 1;
		[_targetPosition,_attackType,_approachBearing,_vehicleClass] spawn KISKA_fnc_CAS;
		
		// if support still has uses left
		private _useCount = _args select 2;
		if (_useCount > 1) then {
			_useCount = _useCount - 1;
			ADD_SUPPORT_BACK(_useCount)
		};

		UNLOAD_GLOBALS
	},
	_params,
	{
		ADD_SUPPORT_BACK(_args select 2)
		UNLOAD_GLOBALS
	}
] spawn KISKA_fnc_commandMenuTree;


nil