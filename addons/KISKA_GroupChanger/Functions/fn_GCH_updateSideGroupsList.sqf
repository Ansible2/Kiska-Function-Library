/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_updateSideGroupsList

Description:
	Updates the side's groups list for the GCH dialog.

Parameters:
	0: _queryForGroups <BOOL> - Does a search for all groups that can appear in the 
        Group Changer need to be reconducted?

Returns:
	NOTHING

Examples:
    (begin example)
        [true] call KISKA_fnc_GCH_updateSideGroupsList;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCH_updateSideGroupsList";

#define PLAYER_GROUP_COLOR [0,1,0,0.6] // Green

if !([] call KISKA_fnc_GCH_isOpen) exitWith {};

params [
    ["_queryForGroups",true,[true]]
];

// TODO: Make sure the group that was selected remains so

private _listControl = localNamespace getVariable ["KISKA_GCH_sidesGroupListBox_ctrl",controlNull];
if (isNull _listControl) exitWith {
    ["_listControl is null",false] call KISKA_fnc_log;
    nil
};


lbClear _listControl;

private _sideGroups = localNamespace getVariable ["KISKA_GCH_sideGroupsArray",[]];
if (_queryForGroups OR (_sideGroups isEqualTo [])) then {
    private _playerSide = [] call KISKA_fnc_GCH_getPlayerSide;
    _sideGroups = [_playerSide] call KISKA_fnc_GCH_getSideGroups;
    localNamespace setVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];
};

// as a user, i want to maintain my current selection when the group list updates

// add to listbox
private "_index";
private _playerGroup = group player;
private _selectedGroup = call KISKA_fnc_GCH_getSelectedGroup;
private _selectedGroupIsNotNull = !(isNull _selectedGroup);
{
    _index = _listControl lbAdd (groupId _x);
    // saving the index as a value so that it can be referenced against the _sideGroups array
    _listControl lbSetValue [_index,_forEachIndex];

    // highlight the player group
    if (_x isEqualTo _playerGroup) then {
        _listControl lbSetColor [_index, PLAYER_GROUP_COLOR];
    };
    
    if (_selectedGroupIsNotNull AND (_x isEqualTo _selectedGroup)) then {
        _listControl lbSetCurSel _index;
    };
} forEach _sideGroups;

// sort list alphabetically
lbSort _listControl;


nil
