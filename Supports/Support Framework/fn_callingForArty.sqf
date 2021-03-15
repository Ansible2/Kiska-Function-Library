#include "Headers\Support Classes.hpp"
#include "Headers\Command Menus.hpp"
#include "Headers\Arty Ammo Classes.hpp"
#include "Headers\Command Menu Macros.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForSupportMaster

Description:
	Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.
	
	This is essentially just another level of abrstraction to be able to more easily reuse
	 code between similar supports and make things easier to read instead of fitting it all
	 in the config.

Parameters:
	0: _caller <OBJECT> - The player calling for support
	1: _targetPosition <ARRAY> - The position (AGLS) at which the call is being made 
		(where the player is looking or if in the map, the position where their cursor is)
	2: _target <OBJECT> - The cursorTarget object of the player
	3: _is3d <BOOL> - False if in map, true if not
	4: _commMenuId <NUMBER> The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
	5: _supportClass <CONFIG> - The config path as defined in the CfgCommunicationMenu
	6: _roundCount <NUMBER> - Number of rounds to allow use of, if < 0, config default amount is used

Returns:
	NOTHING

Examples:
    (begin example)
		[] call KISKA_fnc_callingForArty;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForArty";

#define WITH_USER(GVAR) "#USER:" + GVAR
#define ADD_SUPPORT_BACK [_args select 0,_args select 5,nil,_args select 6,""] call BIS_fnc_addCommMenuItem;
#define UNLOAD_GLOBALS (_args select 7) apply {missionNamespace setVariable [_x,nil]};
#define TO_STRING(STRING) #STRING
#define MAX_KEYS 9
#define AMMO_TYPE_MENU_GVAR "KISKA_menu_ammoSelect"
#define ROUND_COUNT_MENU_GVAR "KISKA_menu_roundCount"

params [
	"_caller",
	"_targetPosition",
	"_target",
	"_is3d",
	"_commMenuId",
	"_supportClass",
	"_roundCount"
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
if (isNull _supportConfig) exitWith {
	[["Could not find class: ",_supportClass," in any config!"],true] call KISKA_fnc_log;
};


private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done

/* ----------------------------------------------------------------------------
	Ammo Menu
---------------------------------------------------------------------------- */
private _ammoMenu = [
	["Select Ammo",false]
];
// get allowed ammo types from config
private _ammoIds = [_supportConfig >> "ammoTypes"] call BIS_fnc_getCfgDataArray;

// create formatted array to use in menu
private ["_ammoClass","_ammoTitle","_keyCode"];
{
	if (_forEachIndex <= MAX_KEYS) then {
		// key codes are offset by 2 (1 on the number bar is key code 2)
		_keyCode = _forEachIndex + 2;
	} else {
		_keyCode = 0;
	};
	_ammoClass = [_x] call KISKA_fnc_getAmmoClassFromId;
	_ammoTitle = [_x] call KISKA_fnc_getAmmoTitleFromId;

	_ammoMenu pushBack STD_LINE_PUSH(_ammoTitle,_keyCode,_ammoClass);
} forEach _ammoIds;
missionNamespace setVariable [AMMO_TYPE_MENU_GVAR,_ammoMenu];


// push to arrays
_menuVariables pushBack AMMO_TYPE_MENU_GVAR;
_menuPathArray pushBack WITH_USER(AMMO_TYPE_MENU_GVAR);



/* ----------------------------------------------------------------------------
	Radius Menu
---------------------------------------------------------------------------- */
private _canSelectRadius = [_supportConfig >> "canSelectRadius"] call BIS_fnc_getCfgDataBool;
if (_canSelectRadius) then {
	// MAKE THIS INTO A CBA SETTING THAT PEOPLE CAN CHANGE
	[TO_STRING(RADIUS_MENU)] call KISKA_fnc_initCommandMenu;


	_menuVariables pushBack TO_STRING(RADIUS_MENU);
	_menuPathArray pushBack WITH_USER(TO_STRING(RADIUS_MENU));
};


/* ----------------------------------------------------------------------------
	Round Count Menu
---------------------------------------------------------------------------- */
private _roundsMenu = [
	["Number of Rounds",false]
];
private _canSelectRounds = [_supportConfig >> "canSelectRounds"] call BIS_fnc_getCfgDataBool;
// get default round count from config
if (_roundCount < 0) then {
	_roundCount = [_supportConfig >> "roundCount"] call BIS_fnc_getCfgData;
};

if (_canSelectRounds) then {
	for "_i" from 1 to _roundCount do {
		if (_i <= MAX_KEYS) then {
			_keyCode = _i + 1;
		} else {
			_keyCode = 0;
		};
		_roundsMenu pushBack STD_LINE_PUSH([_i,"Round(s)"] joinString " ",_keyCode,_i);
	};
} else {
	_roundsMenu pushBack STD_LINE_PUSH([_roundCount,"Round(s)"] joinString " ",2,_roundCount);
};
missionNamespace setVariable [ROUND_COUNT_MENU_GVAR,_roundsMenu];


_menuVariables pushBack ROUND_COUNT_MENU_GVAR;
_menuPathArray pushBack WITH_USER(ROUND_COUNT_MENU_GVAR);


/* ----------------------------------------------------------------------------
	Create Menu
---------------------------------------------------------------------------- */
private _params = _this; // just for readability
_params pushBack _menuVariables;


[
	_menuPathArray,
	{
		params ["_ammo","_radius","_numberOfRounds"];
		
		[_args select 1,_ammo,_radius,_numberOfRounds] spawn KISKA_fnc_virtualArty;
		
		// if support still has rounds available, add it back with the new round count
		if (_numberOfRounds < (_args select 6)) then {
			ADD_SUPPORT_BACK
		};

		UNLOAD_GLOBALS
	},
	_params,
	{
		ADD_SUPPORT_BACK
		UNLOAD_GLOBALS
	}
] spawn KISKA_fnc_commandMenuTree;