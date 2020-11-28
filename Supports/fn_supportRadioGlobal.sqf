/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportRadioGlobal

Description:
	Decides what radio message to play to all players when a support is called.

Parameters:
	0: _messageType <STRING> - The type of radio message to send

Returns:
	NOTHING

Examples:
    (begin example)

		["artillery"] call KISKA_fnc_supportRadioGlobal;

    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportRadioGlobal";

params [
	"_messageType",
	["_caller",player,[objNull]]
];

private "_messageArray";
switch _messageType do {
	case "artillery": {
		_messageArray = [
			"mp_groundsupport_45_artillery_BHQ_0",
			"mp_groundsupport_45_artillery_BHQ_1",
			"mp_groundsupport_45_artillery_BHQ_2",
			"mp_groundsupport_45_artillery_IHQ_0",
			"mp_groundsupport_45_artillery_IHQ_1",
			"mp_groundsupport_45_artillery_IHQ_2"
		];
	};

	case "strike": {
		_messageArray = [
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

	case "supply drop": {
		_messageArray = [
			"mp_groundsupport_10_slingloadsucceeded_BHQ_0",
			"mp_groundsupport_10_slingloadsucceeded_BHQ_1",
			"mp_groundsupport_10_slingloadsucceeded_BHQ_2",
			"mp_groundsupport_10_slingloadsucceeded_IHQ_0",
			"mp_groundsupport_10_slingloadsucceeded_IHQ_1",
			"mp_groundsupport_10_slingloadsucceeded_IHQ_2"
		];
	};

	case "supply drop requested": {
		_messageArray = [
			"mp_groundsupport_01_slingloadrequested_BHQ_0",
			"mp_groundsupport_01_slingloadrequested_BHQ_1",
			"mp_groundsupport_01_slingloadrequested_BHQ_2",
			"mp_groundsupport_01_slingloadrequested_IHQ_0",
			"mp_groundsupport_01_slingloadrequested_IHQ_1",
			"mp_groundsupport_01_slingloadrequested_IHQ_2"
		];
	};

	case "cas request": {
		_messageArray = [
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

	case "uav request": {
		_messageArray = [
			"mp_groundsupport_60_uav_BHQ_0",
			"mp_groundsupport_60_uav_BHQ_1",
			"mp_groundsupport_60_uav_BHQ_2",
			"mp_groundsupport_60_uav_IHQ_0",
			"mp_groundsupport_60_uav_IHQ_1",
			"mp_groundsupport_60_uav_IHQ_2"
		];
	};

	case "transport request": {
		_messageArray = [
			"mp_groundsupport_01_transportrequested_BHQ_0",
			"mp_groundsupport_01_transportrequested_BHQ_1",
			"mp_groundsupport_01_transportrequested_BHQ_2",
			"mp_groundsupport_01_transportrequested_IHQ_0",
			"mp_groundsupport_01_transportrequested_IHQ_1",
			"mp_groundsupport_01_transportrequested_IHQ_2"
		];
	};

	default {
		_messageArray = ["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0"];
	};
};

private _message = selectRandom _messageArray;

[_caller,_message] remoteExec ["sideRadio",call CBA_fnc_players];