/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_addAttachLogicGroup

Description:
    Adds a group to the global attachTo logics map used to store them for reference.

Parameters:
    0: _logicGroup <GROUP> - The group to add

Returns:
    NOTHING

Examples:
    (begin example)
        [createGroup sideLogic] call KISKA_fnc_ambientAnim_getAttachToLogicGroup;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_addAttachLogicGroup";

params [
    ["_logicGroup",grpNull,[grpNull]]
];

private _logicSide = side _logicGroup;
if (_logicSide isNotEqualTo sideLogic) exitWith {
    [
        [
            "Group: ",
            _logicGroup,
            " is not a valid side of sideLogic, it is side: ",
            _logicSide
        ],
        true
    ] call KISKA_fnc_log;
    nil
};

private _logicGroupsMap = call KISKA_fnc_ambientAnim_getAttachLogicGroupsMap;

private _id = ["KISKA_ambientAnimGroup_ID"] call KISKA_fnc_idCounter;
_logicGroup setVariable ["KISKA_ambientAnimGroup_ID",_id];
_logicGroupsMap set [_id,_logicGroup];


nil
