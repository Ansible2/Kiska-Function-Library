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

private _listControl = localNamespace getVariable ["KISKA_GCH_sidesGroupListBox_ctrl",controlNull];
if (isNull _listControl) exitWith {
    ["_listControl is null",true] call KISKA_fnc_log;
    nil
};


lbClear _listControl;

private _sideGroups = localNamespace getVariable ["KISKA_GCH_sideGroupsArray",[]];
if (_queryForGroups OR (_sideGroups isEqualTo [])) then {
    private _playerSide = [] call KISKA_fnc_GCH_getPlayerSide;
    _sideGroups = [_playerSide] call KISKA_fnc_GCH_getSideGroups;
    localNamespace setVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];
};

private _selectedGroup = call KISKA_fnc_GCH_getSelectedGroup;
private _groupWasPreviouslySelected = !(isNull _selectedGroup);

if (_sideGroups isEqualTo []) exitWith {
    if (_groupWasPreviouslySelected) then {
        call KISKA_fnc_GCH_updateCurrentGroupSection;
    };

    nil
};

// add to listbox
private _selectedIndex = -1;
private _playerGroup = group player;

{
    private _index = _listControl lbAdd (groupId _x);
    // saving the index as a value so that it can be referenced against the _sideGroups array
    _listControl lbSetValue [_index,_forEachIndex];

    // highlight the player group
    if (_x isEqualTo _playerGroup) then {
        _listControl lbSetColor [_index, PLAYER_GROUP_COLOR];
    };
    
    if (_groupWasPreviouslySelected AND (_x isEqualTo _selectedGroup)) then {
        _selectedIndex = _forEachIndex;
    };
} forEach _sideGroups;


// sort list alphabetically
lbSort _listControl;

private _selectedGroupNotInList = _selectedIndex < 0;
if (_selectedGroupNotInList) exitWith {
    if (_groupWasPreviouslySelected) then {
        call KISKA_fnc_GCH_updateCurrentGroupSection;
    };

    nil
};

private _listSize = lbSize _listControl;
for "_listBoxIndex" from 0 to (_listSize - 1) do {
    private _sideGroupsIndexOfLbEntry = _listControl lbValue _listBoxIndex;
    
    if (_sideGroupsIndexOfLbEntry isEqualTo _selectedIndex) then {
        _listControl lbSetCurSel _listBoxIndex;
        break;
    };
};



nil
