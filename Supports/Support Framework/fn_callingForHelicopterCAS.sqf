#include "Headers\Command Menu Macros.hpp"
#include "Headers\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForHelicopterCAS

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
		4: _commMenuId <NUMBER> - The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
		5: _supportType <NUMBER> - The Support Type ID
	2: _count <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)
	3: _type <NUMBER> - Determines if either Attack Helicopter CAS or Transport gunners

Returns:
	NOTHING

Examples:
    (begin example)
		[] call KISKA_fnc_callingForHelicopterCAS;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForHelicopterCAS";

#define MIN_RADIUS 200
#define SPEED_LIMIT 10

params [
	"_supportClass",
	"_commMenuArgs",
	["_useCount",-1]
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
if (isNull _supportConfig) exitWith {
	[["Could not find class: ",_supportClass," in any config!"],true] call KISKA_fnc_log;
	nil
};


private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done

// get use count from config if -1
if (_useCount < 0) then {
	_useCount = getNumber(_supportConfig >> "useCount");
	_this set [2,_useCount];
};

/* ----------------------------------------------------------------------------
	Vehicle Select Menu
---------------------------------------------------------------------------- */
private _vehicles = [_supportConfig >> "vehicleTypes"] call BIS_fnc_getCfgDataArray;
if (_vehicles isEqualTo []) then {
	_vehicles = [side (_commMenuArgs select 0),_commMenuArgs select 5] call KISKA_fnc_getSupportVehicleClasses;
};

private _vehicleMenu = [_vehicles] call KISKA_fnc_createVehicleSelectMenu;
SAVE_AND_PUSH(VEHICLE_SELECT_MENU_STR,_vehicleMenu)


/* ----------------------------------------------------------------------------
	Bearings Menu
---------------------------------------------------------------------------- */
_bearingsMenu = BEARING_MENU;

SAVE_AND_PUSH(BEARING_MENU_STR,_bearingsMenu)


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

private _keyCode = 0;
private _radiusMenu = [
	["Engagment Area",false]
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
SAVE_AND_PUSH(RADIUS_MENU_STR,_radiusMenu)


/* ----------------------------------------------------------------------------
	flyInHeight Menu
---------------------------------------------------------------------------- */
private _flyInHeights = [_supportConfig >> "flyinHeights"] call BIS_fnc_getCfgDataArray;
if (_flyInHeights isEqualTo []) then {
	_flyInHeights = missionNamespace getVariable ["KISKA_CBA_supp_flyInHeights_arr",[]];

	if (_flyInHeights isEqualTo []) then {
		_flyInHeights = [50];
	};
};

private _flyInHeightMenu = [
	["Altitude",false]
];
{
	_flyInHeightMenu pushBackUnique DISTANCE_LINE(_x,0);
} forEach _flyInHeights;
SAVE_AND_PUSH(FLYIN_HEIGHT_MENU_STR,_flyInHeightMenu)




/* ----------------------------------------------------------------------------
	Create Menu Path
---------------------------------------------------------------------------- */
private _args = _this; // just for readability
_args pushBack _menuVariables;

private _timeOnStation = [_supportConfig >> "timeOnStation"] call BIS_fnc_getCfgData;
_args pushBack _timeOnStation;

[
	_menuPathArray,
	{
		params ["_vehicleClass","_approachBearing","_attackRadius","_flyinHeight"];

		private _useCount = _args select 2;
		// if a ctrl key is held and one left clicks to select the support while in the map, they can call in an infinite number of the support
		if (visibleMap AND {missionNamespace getVariable ["KISKA_ctrlDown",false]}) exitWith {
			hint parseText "<t color='#ff0000'>You can't call in a support while holding down a crtl key and in the map. It causes a bug with the support menu.</t>";
			ADD_SUPPORT_BACK(_useCount)
		};

		private _commMenuArgs = _args select 1;
		private _targetPosition = _commMenuArgs select 1;
		private _timeOnStation = _args select 4;
		[
			_targetPosition,
			_attackRadius,
			_vehicleClass,
			_timeOnStation,
			SPEED_LIMIT,
			_flyinHeight,
			_approachBearing,
			side (_commMenuArgs select 0) // caller side
		] spawn KISKA_fnc_helicopterGunner;

		[SUPPORT_TYPE_HELI_CAS] call KISKA_fnc_supportNotification;

		// if support still has uses left
		if (_useCount > 1) then {
			_useCount = _useCount - 1;
			ADD_SUPPORT_BACK(_useCount)
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
