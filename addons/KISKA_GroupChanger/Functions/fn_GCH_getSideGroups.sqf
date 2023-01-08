/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_getSideGroups

Description:
    Gets all groups of a particular side and that are not exlcuded from the GCH

Parameters:
    0: _side <SIDE> - The side to get the groups of

Returns:
    <ARRAY> - List of all the groups

Examples:
    (begin example)
        private _playerSide = [] call KISKA_fnc_GCH_getPlayerSide;
        _groups = [_playerSide] call KISKA_fnc_GCH_getSideGroups;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_getSideGroups";

if !(hasInterface) exitWith {[]};

params [
    ["_side",BLUFOR,[sideUnknown]]
];


allGroups select {
    (side _x) isEqualTo _side AND
    (!([_x] call KISKA_fnc_GCH_isGroupExcluded))
};
