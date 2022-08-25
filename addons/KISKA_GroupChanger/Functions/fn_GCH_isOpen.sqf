/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_isOpen

Description:
	

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

private _gchDisplay = localNamespace setVariable ["KISKA_GCH_display",displayNull];


isNull _gchDisplay

