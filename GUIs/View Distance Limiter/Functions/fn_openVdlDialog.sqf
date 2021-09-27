#include "..\ViewDistanceLimiterCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_openVdlDialog

Description:
	Opens the GUI for the VDL system.

Parameters:
	NONE

Returns:
	BOOL

Examples:
	(begin example)
		call KISKA_fnc_openVdlDialog;
	(end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {false};

openMap false;

createDialog VIEW_DISTANCE_LIMITER_DIALOG_STR;
