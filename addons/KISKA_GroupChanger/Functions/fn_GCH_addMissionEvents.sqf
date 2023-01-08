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
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_addMissionEvents";

if !(hasInterface) exitWith {};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};


addMissionEventHandler ["GroupCreated", {
    params ["_group"];
    [_group] call KISKA_fnc_GCH_addGroupEventhandlers;
}];


addMissionEventHandler ["GroupDeleted", {
    params ["_group"];

    private _groupChangerOpen = [] call KISKA_fnc_GCH_isOpen;
    if (_groupChangerOpen) then {
        private _groupIsExcluded = [_group] call KISKA_fnc_GCH_isGroupExcluded;
        private _deletedGroupSide = side _group;
        private _playerSide = [] call KISKA_fnc_GCH_getPlayerSide;

        if ((_playerSide isEqualTo _deletedGroupSide) AND (!_groupIsExcluded)) then {
            [true] call KISKA_fnc_GCH_updateSideGroupsList;
        };
    };
}];


nil
