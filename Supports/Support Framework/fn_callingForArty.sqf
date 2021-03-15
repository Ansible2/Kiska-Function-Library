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
#define ADD_SUPPORT_BACK [_caller,_supportClass,nil,nil,""] call BIS_fnc_addCommMenuItem;
#define ADD_SUPPORT_BACK_MENU(CALLER,CLASS) [CALLER,CLASS,nil,nil,""] call BIS_fnc_addCommMenuItem;
#define TO_STRING(STRING) #STRING


params [
	"_caller",
	"_targetPosition",
	"_target",
	"_is3d",
	"_commMenuId",
	"_supportClass"
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
if (isNull _supportConfig) exitWith {
	[["Could not find class: ",_supportClass," in any config!"],true] call KISKA_fnc_log;
};

private _menuPathArray = [];

private _ammoMenu = [
	["Select Ammo",false]
];
private _ammoIds = [_supportConfig >> "ammoTypes"] call BIS_fnc_getCfgDataArray;
_ammoIds apply {
	[_x] call KISKA_fnc_getAmmoClassFromId
};

_menuPathArray pushBack WITH_USER("");


private _canSelectRadius = [_supportConfig >> "canSelectRadius"] call BIS_fnc_getCfgDataBool;
if (_canSelectRadius) then {
	[TO_STRING(RADIUS_MENU)] call KISKA_fnc_initCommandMenu;
};




[
	_menuPathArray,
	{
		params ["_ammo","_radius","_numberOfRounds"];
		
		[_args select 1,_ammo,_radius,_numberOfRounds] spawn KISKA_fnc_virtualArty;
	},
	_this,
	{
		ADD_SUPPORT_BACK_MENU(_args select 0,_args select 5)
	}
] spawn KISKA_fnc_commandMenuTree;