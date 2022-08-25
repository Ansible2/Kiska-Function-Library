/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_updateSideGroupsList

Description:
	Updates the side's groups list for the GCH dialog.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        [] call KISKA_fnc_GCH_updateSideGroupsList;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCH_updateSideGroupsList";

#define PLAYER_GROUP_COLOR [0,1,0,0.6] // Green


private _listControl = localNamespace getVariable ["KISKA_GCH_sidesGroupListBox_ctrl",controlNull];
if (isNull _listControl) exitWith {
    ["_listControl is null",true] call KISKA_fnc_log;
    nil
};


lbClear _listControl;

private _sideGroups = [side player] call KISKA_fnc_GCH_getSideGroups;
localNamespace setVariable ["KISKA_GCH_sideGroupsArray",_sideGroups];

// add to listbox
private "_index";
private _playerGroup = group player;
{
    _index = _listControl lbAdd (groupId _x);
    // saving the index as a value so that it can be referenced against the _sideGroups array
    _listControl lbSetValue [_index,_forEachIndex];

    // highlight the player group
    if (_x isEqualTo _playerGroup) then {
        _listControl lbSetColor [_index, PLAYER_GROUP_COLOR];
    };
} forEach _sideGroups;

// sort list alphabetically
lbSort _listControl;


nil
