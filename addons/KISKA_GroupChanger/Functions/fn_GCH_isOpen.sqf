/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_isOpen

Description:
	Checks if the group changer is open or not.

Parameters:
	NONE

Returns:
	<BOOL> - Returns true if the group changer is open and false if it is not

Examples:
    (begin example)
        private _isOpen = call KISKA_fnc_GCH_isOpen;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCH_isOpen";

if !(hasInterface) exitWith {false};
private _gchDisplay = localNamespace getVariable ["KISKA_GCH_display",displayNull];


!(isNull _gchDisplay)

