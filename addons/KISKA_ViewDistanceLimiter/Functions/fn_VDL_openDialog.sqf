//#include "..\View DistanceLimiter Common Defines.hpp"
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
scriptName "KISKA_fnc_openVdlDialog";

if (!hasInterface) exitWith {false};

if (missionNamespace getVariable ["KISKA_CBA_VDL_available",true]) exitWith {
    ["The View Distance Limiter Dialog is not available"]
    false
};

if (missionNamespace getVariable ["KISKA_CBA_VDL_closeMap",true]) then {
    openMap false;
};


createDialog "KISKA_viewDistanceLimiter_dialog";
