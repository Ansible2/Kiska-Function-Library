#include "..\ViewDistanceLimiterCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_handleVdlGuiCheckbox

Description:
	Acts as an event when the box is checked or unchecked in the VDL GUI.
	It will either start the system or end it.

Parameters:
	0: _control <CONTROL> - The conrol of the box
	1: _checked <BOOL> - Is the box checked?

Returns:
	BOOL

Examples:
	(begin example)
		// from onCheckedChanged event in config
		_this call KISKA_fnc_handleVdlGuiCheckbox
	(end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
if (!hasInterface) exitWith {};

params ["_control","_checked"];

// turn number into bool
_checked = [false,true] select _checked;

if (_checked) then {
	if !(call KISKA_fnc_isVDLSystemRunning) then {
		[] spawn KISKA_fnc_viewDistanceLimiter;
		["VDL system starting..."] call KISKA_fnc_notification;

	} else {
		VDL_GLOBAL_RUN = true;
		["VDL system resuming..."] call KISKA_fnc_notification;

	};

} else {
	VDL_GLOBAL_RUN = false;
	["VDL system turning off..."] call KISKA_fnc_notification;

};
