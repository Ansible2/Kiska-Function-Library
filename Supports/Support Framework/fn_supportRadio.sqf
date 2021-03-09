#include "Headers\Support Radio Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportRadio

Description:
	Decides what radio message to play to provided targets.

Parameters:
	0: _messageType <STRING> - The type of radio message to send
	1: _caller <OBJECT> - The person sending the call (default is local player)
	2: _targets <NUMBER, OBJECT, STRING, GROUP, SIDE, ARRAY> - The remoteExec targets for the radio call
	
Returns:
	NOTHING

Examples:
    (begin example)
		["artillery"] call KISKA_fnc_supportRadio;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportRadio";

params [
	"_messageType",
	["_caller",player,[objNull]],
	["_targets",side player,[123,objNull,"",BLUFOR,grpNull,[]]]
];

private _fn_selectMessage = {
	if (_messageType == TYPE_ARTILLERY) exitWith {
		selectRandom [
			"mp_groundsupport_45_artillery_BHQ_0",
			"mp_groundsupport_45_artillery_BHQ_1",
			"mp_groundsupport_45_artillery_BHQ_2",
			"mp_groundsupport_45_artillery_IHQ_0",
			"mp_groundsupport_45_artillery_IHQ_1",
			"mp_groundsupport_45_artillery_IHQ_2"
		];
	};

	if (_messageType == TYPE_STRIKE) exitWith {
		selectRandom [
			"mp_groundsupport_70_tacticalstrikeinbound_BHQ_0",
			"mp_groundsupport_70_tacticalstrikeinbound_BHQ_1",
			"mp_groundsupport_70_tacticalstrikeinbound_BHQ_2",
			"mp_groundsupport_70_tacticalstrikeinbound_BHQ_3",
			"mp_groundsupport_70_tacticalstrikeinbound_BHQ_4",
			"mp_groundsupport_70_tacticalstrikeinbound_IHQ_0",
			"mp_groundsupport_70_tacticalstrikeinbound_IHQ_1",
			"mp_groundsupport_70_tacticalstrikeinbound_IHQ_2",
			"mp_groundsupport_70_tacticalstrikeinbound_IHQ_3",
			"mp_groundsupport_70_tacticalstrikeinbound_IHQ_4"
		];
	};

	if (_messageType == TYPE_SUPPLY_DROP) exitWith {
		selectRandom [
			"mp_groundsupport_10_slingloadsucceeded_BHQ_0",
			"mp_groundsupport_10_slingloadsucceeded_BHQ_1",
			"mp_groundsupport_10_slingloadsucceeded_BHQ_2",
			"mp_groundsupport_10_slingloadsucceeded_IHQ_0",
			"mp_groundsupport_10_slingloadsucceeded_IHQ_1",
			"mp_groundsupport_10_slingloadsucceeded_IHQ_2"
		];
	};

	if (_messageType == TYPE_SUPPLY_DROP_REQUEST) exitWith {
		selectRandom [
			"mp_groundsupport_01_slingloadrequested_BHQ_0",
			"mp_groundsupport_01_slingloadrequested_BHQ_1",
			"mp_groundsupport_01_slingloadrequested_BHQ_2",
			"mp_groundsupport_01_slingloadrequested_IHQ_0",
			"mp_groundsupport_01_slingloadrequested_IHQ_1",
			"mp_groundsupport_01_slingloadrequested_IHQ_2"
		];
	};

	if (_messageType == TYPE_CAS_REQUEST) exitWith {
		selectRandom [
			"mp_groundsupport_01_casrequested_BHQ_0",
			"mp_groundsupport_01_casrequested_BHQ_1",
			"mp_groundsupport_01_casrequested_BHQ_2",
			"mp_groundsupport_01_casrequested_IHQ_0",
			"mp_groundsupport_01_casrequested_IHQ_1",
			"mp_groundsupport_01_casrequested_IHQ_2",
			"mp_groundsupport_50_cas_BHQ_0",
			"mp_groundsupport_50_cas_BHQ_1",
			"mp_groundsupport_50_cas_BHQ_2",
			"mp_groundsupport_50_cas_IHQ_0",
			"mp_groundsupport_50_cas_IHQ_1",
			"mp_groundsupport_50_cas_IHQ_2"
		];
	};

	if (_messageType == TYPE_CAS_ABORT) exitWith {
		selectRandom [
			"mp_groundsupport_05_casaborted_BHQ_0",
			"mp_groundsupport_05_casaborted_BHQ_1",
			"mp_groundsupport_05_casaborted_BHQ_2",
			"mp_groundsupport_05_casaborted_IHQ_0",
			"mp_groundsupport_05_casaborted_IHQ_1",
			"mp_groundsupport_05_casaborted_IHQ_2"
		];
	};

	if (_messageType == TYPE_HELO_DOWN) exitWith {
		selectRandom [
			"mp_groundsupport_65_chopperdown_BHQ_0",
			"mp_groundsupport_65_chopperdown_BHQ_1",
			"mp_groundsupport_65_chopperdown_BHQ_2",
			"mp_groundsupport_65_chopperdown_IHQ_0",
			"mp_groundsupport_65_chopperdown_IHQ_1",
			"mp_groundsupport_65_chopperdown_IHQ_2"
		];
	};

	if (_messageType == TYPE_UAV_REQUEST) exitWith {
		selectRandom [
			"mp_groundsupport_60_uav_BHQ_0",
			"mp_groundsupport_60_uav_BHQ_1",
			"mp_groundsupport_60_uav_BHQ_2",
			"mp_groundsupport_60_uav_IHQ_0",
			"mp_groundsupport_60_uav_IHQ_1",
			"mp_groundsupport_60_uav_IHQ_2"
		];
	};

	if (_messageType == TYPE_TRANSPORT_REQUEST) exitWith {
		selectRandom [
			"mp_groundsupport_01_transportrequested_BHQ_0",
			"mp_groundsupport_01_transportrequested_BHQ_1",
			"mp_groundsupport_01_transportrequested_BHQ_2",
			"mp_groundsupport_01_transportrequested_IHQ_0",
			"mp_groundsupport_01_transportrequested_IHQ_1",
			"mp_groundsupport_01_transportrequested_IHQ_2"
		];
	};
	
	"mp_groundsupport_70_tacticalstrikeinbound_BHQ_0"
};

private _message = call _fn_selectMessage;

[_caller,_message] remoteExecCall ["globalRadio",_targets];