#include "Headers\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getSupportVehicleClasses

Description:
	Gets mission configed default vehicle types available for KISKA supports.

Parameters:
	0: _side <SIDE> - The side to search for
	1: _typeId <NUMBER> - The type of vehicle to search for

Returns:
	<ARRAY> - A list of vehicles listed under the relevant config

Examples:
    (begin example)
		_bluforCAS_types = [BLUFOR,SUPPORT_TYPE_CAS] call KISKA_fnc_getSupportVehicleClasses;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getSupportVehicleClasses";

#define RETURN_CONFIG_ARRAY(TYPE_OF,CONFIG) \
	if (_typeID isEqualTo TYPE_OF) exitWith { \
		getArray(missionConfigFile >> "KISKA_supportVehicleTypes" >> CONFIG); \
	};

params ["_side","_typeID"];

if (_side isEqualTo BLUFOR) exitWith {
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_CAS,"CAS_BLUFOR")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_ATTACKHELI_CAS,"attackHeliCAS_BLUFOR")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_HELI_CAS,"heliCAS_BLUFOR")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_ARSENAL_DROP,"arsenalDrop_BLUFOR")
};

if (_side isEqualTo OPFOR) exitWith {
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_CAS,"CAS_OPFOR")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_ATTACKHELI_CAS,"attackHeliCAS_OPFOR")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_HELI_CAS,"heliCAS_OPFOR")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_ARSENAL_DROP,"arsenalDrop_OPFOR")
};

if (_side isEqualTo independent) exitWith {
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_CAS,"CAS_INDEP")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_ATTACKHELI_CAS,"attackHeliCAS_INDEP")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_HELI_CAS,"heliCAS_INDEP")
	RETURN_CONFIG_ARRAY(SUPPORT_TYPE_ARSENAL_DROP,"arsenalDrop_INDEP")
};


[]