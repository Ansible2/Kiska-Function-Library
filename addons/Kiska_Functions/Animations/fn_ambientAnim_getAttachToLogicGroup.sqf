/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_getAttachToLogicGroup

Description:
	Returns the ambient animation logic group that all attachTo logics that are
	 created for the ambient animation system are placed into.

Parameters:
	NONE

Returns:
    <GROUP> - The logic group

Examples:
    (begin example)
		private _logicGroup = call KISKA_fnc_ambientAnim_getAttachToLogicGroup;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_getAttachToLogicGroup";

missionNamespace getVariable ["KISKA_ambientAnim_attachToLogicGroup",grpNull]