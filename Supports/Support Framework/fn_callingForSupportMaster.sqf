#include "Headers\CAS Type IDs.hpp"
#include "Headers\Arty Ammo Type IDs.hpp"
#include "Headers\Command Menus.hpp"
#include "Headers\Arty Ammo Classes.hpp"
#include "Headers\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForSupportMaster

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
	2: _count <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)

Returns:
	NOTHING

Examples:
    (begin example)
		["myClass",_this] call KISKA_fnc_callingForSupportMaster;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForSupportMaster";

#define ADD_SUPPORT_BACK_MENU(CALLER,CLASS,ARGS) [CALLER,CLASS,nil,nil,""] call KISKA_fnc_addCommMenuItem;

params [
	["_supportClass","",[""]],
	"_commMenuArgs",
	"_count"
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
private _supportTypeId = [_supportConfig >> "supportTypeId"] call BIS_fnc_getCfgData;

if (_supportTypeId isEqualTo SUPPORT_TYPE_ARTY) exitWith {
	_this call KISKA_fnc_callingForArty;
};

if (_supportTypeId isEqualTo SUPPORT_TYPE_SUPPLY_DROP) exitWith {

};

if (_supportTypeId isEqualTo SUPPORT_TYPE_HELI_CAS) exitWith {

};

if (_supportTypeId isEqualTo SUPPORT_TYPE_CAS) exitWith {
	_this call KISKA_fnc_callingForCAS;
};


_commMenuArgs params [
	"_caller",
	"_targetPosition",
	"_target",
	"_is3d",
	"_commMenuId"
];







/* ----------------------------------------------------------------------------
	Other
---------------------------------------------------------------------------- */


/* ----------------------------------------------------------------------------
	155 Artillery
---------------------------------------------------------------------------- */



/* ----------------------------------------------------------------------------
	120 Artillery
---------------------------------------------------------------------------- */



/* ----------------------------------------------------------------------------
	82 Mortar
---------------------------------------------------------------------------- */



/* ----------------------------------------------------------------------------
	Supplies
---------------------------------------------------------------------------- */


/* ----------------------------------------------------------------------------
	CAS
---------------------------------------------------------------------------- */


/* ----------------------------------------------------------------------------
	Helicopter CAS
---------------------------------------------------------------------------- */
/*
#define ADD_SUPPORT_BACK [_caller,_supportClass,nil,nil,""] call BIS_fnc_addCommMenuItem;
#define ADD_SUPPORT_BACK_MENU(CALLER,CLASS) [CALLER,CLASS,nil,nil,""] call BIS_fnc_addCommMenuItem;
#define TO_STRING(STRING) #STRING

#define CHECK_POSITION \
if (_targetPosition isEqualTo []) exitWith { \
	[["WARNING",1.1,[0.75,0,0,1]],"Position is invalid, try again",false] call CBA_fnc_notify; \
	ADD_SUPPORT_BACK \
};

#define CHECK_SUPPORT_CLASS(SUPPORT_CLASS_COMPARE) _supportClass == TO_STRING(SUPPORT_CLASS_COMPARE)

#define ARTY_EXPRESSION(AMMO_TYPE,ROUND_COUNT) CHECK_POSITION [_targetPosition,AMMO_TYPE,25,ROUND_COUNT] spawn KISKA_fnc_virtualArty

#define CAS_RADIO [TYPE_CAS_REQUEST] call KISKA_fnc_supportRadio;

#define CAS_EXPRESSSION(CAS_TYPE) \
	CHECK_POSITION \
	_targetPosition = AGLToASL(_targetPosition);\
	private _friendlyAttackAircraftClass = [6] call BLWK_fnc_getFriendlyVehicleClass;\
	[_targetPosition,CAS_TYPE,getDir _caller,_friendlyAttackAircraftClass] spawn KISKA_fnc_CAS;\
	CAS_RADIO

#define HELI_CAS_EXPRESSION(VEHICLE_TYPE,TIME_ON_STATION,FLYIN_ALT,DEFAULT_TYPE,GLOBAL_VAR) \
	[BLWK_playAreaCenter,BLWK_playAreaRadius,VEHICLE_TYPE,TIME_ON_STATION,10,FLYIN_ALT,-1,DEFAULT_TYPE,GLOBAL_VAR] call BLWK_fnc_passiveHelicopterGunner; \
	CAS_RADIO


if (CHECK_SUPPORT_CLASS(CLASS_155_ARTY_VARIABLE_8)) exitWith {
	[TO_STRING(AMMO_155_MENU)] call KISKA_fnc_initCommandMenu;
	[TO_STRING(RADIUS_MENU)] call KISKA_fnc_initCommandMenu;
	[TO_STRING(COUNT_TO_EIGHT_MENU)] call KISKA_fnc_initCommandMenu;
	
	[
		[WITH_USER(AMMO_155_MENU),WITH_USER(RADIUS_MENU),WITH_USER(COUNT_TO_EIGHT_MENU)],
		{
			params ["_ammo","_radius","_numberOfRounds"];
			
			[_args select 1,_ammo,_radius,_numberOfRounds] spawn KISKA_fnc_virtualArty;
		},
		_commMenuArgs,
		{
			ADD_SUPPORT_BACK_MENU(_args select 0,TO_STRING(CLASS_155_ARTY_VARIABLE))
		}
	] spawn KISKA_fnc_commandMenuTree;
};
*/