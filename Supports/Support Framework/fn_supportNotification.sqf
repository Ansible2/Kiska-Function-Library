#include "Headers\Support Type IDs.hpp"
#include "Headers\Support Radio Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportNotification

Description:
	Gives the player a sound or text notification that they called in a support
	 from the KISKA systems. Just used for feedback to know a call was placed.

	Players can adjust the notifcation settings in the CBA addon menu.

Parameters:
	0: _supportTypeId <NUMBER> - The support type that was called

Returns:
	NOTHING

Examples:
    (begin example)
		[0] call KISKA_fnc_supportNotification;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportNotification";

#define NONE 0
#define RADIO_ONLY 1
#define TEXT_ONLY 2
#define BOTH 3

#define GET_NOTIFCAITON(GVAR,SUPPORT_ID,RADIO_ID) \
	if (_supportTypeId isEqualTo SUPPORT_ID) exitWith { \
		private _notificationSetting = missionNamespace getVariable [GVAR,0]; \
		if (_notificationSetting isEqualTo NONE) exitWith {}; \
		if (_notificationSetting isEqualTo RADIO_ONLY) exitWith { \
			[RADIO_ID] call KISKA_fnc_supportRadio; \
		}; \
		if (_notificationSetting isEqualTo TEXT_ONLY) exitWith { \
			["Request Received",0,false] call KISKA_fnc_datalinkMsg; \
		}; \
		if (_notificationSetting isEqualTo BOTH) exitWith { \
			[RADIO_ID] call KISKA_fnc_supportRadio; \
			["Request Received",0,false] call KISKA_fnc_datalinkMsg; \
		}; \
	};


if (!hasInterface) exitWith {};

params [
	["_supportTypeId",0,[123]]
];


GET_NOTIFCAITON("KISKA_suppNotif_arty",SUPPORT_TYPE_ARTY,TYPE_ARTILLERY)

GET_NOTIFCAITON("KISKA_suppNotif_cas",SUPPORT_TYPE_CAS,TYPE_CAS_REQUEST)

GET_NOTIFCAITON("KISKA_suppNotif_heliCas",SUPPORT_TYPE_ATTACKHELI_CAS,TYPE_CAS_REQUEST)
GET_NOTIFCAITON("KISKA_suppNotif_heliCas",SUPPORT_TYPE_HELI_CAS,TYPE_CAS_REQUEST)