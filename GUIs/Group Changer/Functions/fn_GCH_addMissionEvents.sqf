/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_addMissionEvents

Description:
	Adds mission event handlers for keeping track of groups.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        PRE-INIT function
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_addMissionEvents";


addMissionEventHandler ["GroupCreated", {
    if !(isNull (uiNamespace getVariable ["KISKA_GCH_display",displayNull])) then {
        [] call KISKA_fnc_GCH_updateSideGroupsList;
    };
}];


addMissionEventHandler ["GroupDeleted", {
    if !(isNull (uiNamespace getVariable ["KISKA_GCH_display",displayNull])) then {
        [] call KISKA_fnc_GCH_updateSideGroupsList;
    };
}];


nil
