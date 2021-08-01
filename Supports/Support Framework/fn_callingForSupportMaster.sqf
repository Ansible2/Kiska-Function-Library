#include "Headers\Command Menu Macros.hpp"
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
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForSupportMaster";

params [
	["_supportClass","",[""]],
	"_commMenuArgs",
	["_count",-1]
];

// delete comm menu id from use hash
KISKA_playersSupportMap deleteAt (_commMenuArgs select 4);

private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
private _supportTypeId = [_supportConfig >> "supportTypeId"] call BIS_fnc_getCfgData;
_commMenuArgs pushBack _supportTypeId;

if (_supportTypeId isEqualTo SUPPORT_TYPE_ARTY) exitWith {
	_this call KISKA_fnc_callingForArty;
};

if (_supportTypeId isEqualTo SUPPORT_TYPE_SUPPLY_DROP) exitWith {

};

if (_supportTypeId isEqualTo SUPPORT_TYPE_HELI_CAS OR {_supportTypeId isEqualTo SUPPORT_TYPE_ATTACKHELI_CAS}) exitWith {
	_this call KISKA_fnc_callingForHelicopterCAS;
};

if (_supportTypeId isEqualTo SUPPORT_TYPE_CAS) exitWith {
	_this call KISKA_fnc_callingForCAS;
};

if (_supportTypeId isEqualTo SUPPORT_TYPE_ARSENAL_DROP) exitWith {
	_this call KISKA_fnc_callingForArsenalSupplyDrop
};


_commMenuArgs params [
	"_caller",
	"_targetPosition",
	"_target",
	"_is3d",
	"_commMenuId"
];


nil
