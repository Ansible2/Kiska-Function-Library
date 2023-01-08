/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_getSelectedGroup

Description:
    Returns the selected group in the group changer.

Parameters:
    NONE

Returns:
    <GROUP> - The currently selected group or grpNull if not found

Examples:
    (begin example)
        private _selectedGroup = [] call KISKA_fnc_GCH_getSelectedGroup;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_getSelectedGroup";

if !(hasInterface) exitWith {grpNull};

localNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull]