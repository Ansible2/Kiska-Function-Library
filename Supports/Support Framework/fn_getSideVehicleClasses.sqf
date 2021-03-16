#include "Headers\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getSideVehicleClasses

Description:
	Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.
	
	This is essentially just another level of abrstraction to be able to more easily reuse
	 code between similar supports and make things easier to read instead of fitting it all
	 in the config.

Parameters:
	0: _side <SIDE> - The side to search for
	1: _typeId <NUMBER> - The type of vehicle to search for

Returns:
	NOTHING

Examples:
    (begin example)
		_bluforClasses = [BLUFOR] call KISKA_fnc_getSideVehicleClasses;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getSideVehicleClasses";