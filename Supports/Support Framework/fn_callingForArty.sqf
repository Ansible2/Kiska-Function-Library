#include "Headers\Arty Ammo Classes.hpp"
#include "Headers\Command Menu Macros.hpp"
#include "Headers\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForArty

Description:
	Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.

	This is essentially just another level of abrstraction to be able to more easily reuse
	 code between similar supports and make things easier to read instead of fitting it all
	 in the config.

Parameters:
	0: _supportClass <STRING> - The class as defined in the CfgCommunicationMenu
	1: _commMenuArgs <ARRAY> - The arguements passed by the CfgCommunicationMenu entry
		0: _caller <OBJECT> - The player calling for support
		1: _targetPosition <ARRAY> - The position (AGLS) at which the call is being made
			(where the player is looking or if in the map, the position where their cursor is)
		2: _target <OBJECT> - The cursorTarget object of the player
		3: _is3d <BOOL> - False if in map, true if not
		4: _commMenuId <NUMBER> The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
		5: _supportType <NUMBER> - The Support Type ID
	2: _roundCount <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)

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

#define AMMO_TYPE_MENU_GVAR "KISKA_menu_ammoSelect"
#define ROUND_COUNT_MENU_GVAR "KISKA_menu_roundCount"
#define RADIUS_MENU_GVAR "KISKA_menu_radius"
#define MIN_RADIUS 25


params [
	"_supportClass",
	"_commMenuArgs",
	"_roundCount"
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
if (isNull _supportConfig) exitWith {
	[["Could not find class: ",_supportClass," in any config!"],true] call KISKA_fnc_log;
	nil
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

SAVE_AND_PUSH(AMMO_TYPE_MENU_GVAR,_ammoMenu)


/* ----------------------------------------------------------------------------
	Radius Menu
---------------------------------------------------------------------------- */
private _selectableRadiuses = [_supportConfig >> "radiuses"] call BIS_fnc_getCfgDataArray;
if (_selectableRadiuses isEqualTo []) then {
	_selectableRadiuses = missionNamespace getVariable ["KISKA_CBA_supp_radiuses_arr",[]];

	if (_selectableRadiuses isEqualTo []) then {
		_selectableRadiuses = [200];
	};
};

private _radiusMenu = [
	["Area Spread",false]
];
{
	if (_forEachIndex <= MAX_KEYS) then {
		// key codes are offset by 2 (1 on the number bar is key code 2)
		_keyCode = _forEachIndex + 2;
	} else {
		_keyCode = 0;
	};

	if (_x < MIN_RADIUS) then {
		_radiusMenu pushBackUnique DISTANCE_LINE(MIN_RADIUS,_keyCode);
	} else {
		_radiusMenu pushBackUnique DISTANCE_LINE(_x,_keyCode);
	};
} forEach _selectableRadiuses;

SAVE_AND_PUSH(RADIUS_MENU_GVAR,_radiusMenu)


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
	_this set [2,_roundCount]; // update round count to be passed to KISKA_fnc_commandMenuTree
};

private _roundsString = "";
if (_canSelectRounds) then {
	for "_i" from 1 to _roundCount do {
		if (_i <= MAX_KEYS) then {
			_keyCode = _i + 1;
		} else {
			_keyCode = 0;
		};
		_roundsString = [_i,"Round(s)"] joinString " ";
		_roundsMenu pushBack STD_LINE_PUSH(_roundsString,_keyCode,_i);
	};
} else {
	_roundsString = [_roundCount,"Round(s)"] joinString " ";
	_roundsMenu pushBack STD_LINE_PUSH(_roundsString,2,_roundCount);
};

SAVE_AND_PUSH(ROUND_COUNT_MENU_GVAR,_roundsMenu)


/* ----------------------------------------------------------------------------
	Create Menu
---------------------------------------------------------------------------- */
private _args = _this; // just for readability
_args pushBack _menuVariables;


[
	_menuPathArray,
	{
		params ["_ammo","_radius","_numberOfRounds"];

		private _roundsAvailable = _args select 2;
		// if a ctrl key is held and one left clicks to select the support while in the map, they can call in an infinite number of the support
		if (visibleMap AND {missionNamespace getVariable ["KISKA_ctrlDown",false]}) exitWith {
			hint parseText "<t color='#ff0000'>You can't call in a support while holding down a crtl key and in the map. It causes a bug with the support menu.</t>";
			ADD_SUPPORT_BACK(_roundsAvailable)
		};

		private _commMenuArgs = _args select 1;
		private _targetPosition = _commMenuArgs select 1;
		[_targetPosition,_ammo,_radius,_numberOfRounds] spawn KISKA_fnc_virtualArty;

		[SUPPORT_TYPE_ARTY] call KISKA_fnc_supportNotification;

		// if support still has rounds available, add it back with the new round count
		if (_numberOfRounds < _roundsAvailable) then {
			_roundsAvailable = _roundsAvailable - _numberOfRounds;
			ADD_SUPPORT_BACK(_roundsAvailable)
		};

		UNLOAD_GLOBALS
	},
	_args,
	{
		ADD_SUPPORT_BACK(_args select 2)
		UNLOAD_GLOBALS
	}
] spawn KISKA_fnc_commandMenuTree;


nil
