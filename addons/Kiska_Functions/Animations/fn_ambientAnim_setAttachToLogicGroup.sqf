/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_setAttachToLogicGroup

Description:
	Sets the attachTo logic group that the ambient animation system useA

Parameters:
	0: _logicGroup <GROUP> - The group to set to KISKA_ambientAnim_attachToLogicGroup. Must be sideLogic.

Returns:
    NOTHING

Examples:
    (begin example)
		[
			createGroup sideLogic
		] call KISKA_fnc_ambientAnim_setAttachToLogicGroup;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_setAttachToLogicGroup";

params [
	["_logicGroup",grpNull,[grpNull]]
];

if (isNull _logicGroup) exitWith {
	["_logicGroup isNull!",true] call KISKA_fnc_log;
	nil
};

private _logicSide = side _logicGroup;
if (_logicSide isNotEqualTo sideLogic) exitWith {
	[["_logicGroup is not of sideLogic, it is of side: ",_logicSide],true] call KISKA_fnc_log;
	nil
};

missionNamespace setVariable ["KISKA_ambientAnim_attachToLogicGroup",_logicGroup];