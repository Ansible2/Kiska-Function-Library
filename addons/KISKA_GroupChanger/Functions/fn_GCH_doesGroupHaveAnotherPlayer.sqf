/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_doesGroupHaveAnotherPlayer

Description:
    Checks if a group contains another player other than the local player

Parameters:
    0: _group <GROUP> - The group to search in

Returns:
    <BOOL> - True if another player is in ther group

Examples:
    (begin example)
        [group player] call KISKA_fnc_GCH_doesGroupHaveAnotherPlayer
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_doesGroupHaveAnotherPlayer";

params [
    ["_group",grpNull,[grpNull]]
];


if (isNull _group) exitWith {
    ["Null group passed"] call KISKA_fnc_log;
    false
};


private _anotherPlayerInGroup = [
    units _group,
    {
        (_x isNotEqualTo player) AND (isPlayer _x)
    }
] call KISKA_fnc_findIfBool;


_anotherPlayerInGroup
