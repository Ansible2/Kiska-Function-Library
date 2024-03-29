/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_isGroupExcluded

Description:
    Checks if a group is excluded from the Group Changer menu.

Parameters:
    0: _group <GROUP> - The group to check exclusion of
    1: _canBeNil <BOOL> - Whether or not to operate under the assumption of a default "true" value.
        if `true`, function can either return a BOOL or nil for the var never having been set

Returns:
    <BOOL or nil> - Returns true if the group is excluded, false if not, or nil if never defined

Examples:
    (begin example)
        private _isExcluded = [group player] call KISKA_fnc_GCH_isGroupExcluded;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_isGroupExcluded";

if !(hasInterface) exitWith {true};

params [
    ["_group",grpNull,[grpNull]],
    ["_canBeNil",false,[true]]
];


if (_canBeNil) exitWith {_group getVariable "KISKA_GCH_exclude"};
_group getVariable ["KISKA_GCH_exclude",true];
