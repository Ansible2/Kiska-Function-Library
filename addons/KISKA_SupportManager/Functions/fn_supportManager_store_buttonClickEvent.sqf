#include "..\Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_store_buttonClickEvent

Description:
    Activates when the take button is pressed and gives player the support.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_supportManager_store_buttonClickEvent;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_store_buttonClickEvent";

disableSerialization;

private _listControl = GET_SM_CURRENT_LIST_CTRL;
private _selectedIndex = lbCurSel _listControl;

if (_selectedIndex isEqualTo -1) exitWith {
    ["You must select an item to store",4] call KISKA_fnc_errorNotification;
};

private _commMenuItems = player getVariable ["BIS_fnc_addCommMenuItem_menu",[]];
private _selectedItemSupportId = _listControl lbValue _selectedIndex;
private _indexToRemove = _commMenuItems findIf {
    (_x select 0) isEqualTo _selectedItemSupportId
};


if (_indexToRemove isEqualTo -1) exitWith {
    [
        [
            "Could not find support to remove with id: ",
            _selectedItemSupportId,
            " -- BIS_fnc_addCommMenuItem_menu is: ",
            _commMenuItems
        ],
        true
    ] call KISKA_fnc_log;

    nil
};


private _kiskaSupportInfo = KISKA_playersSupportMap deleteAt _selectedItemSupportId;
// if support number-of-uses is default amount
if ((_kiskaSupportInfo select 1) isEqualTo -1) then {
    // then change to the shorthand syntax for use with KISKA_fnc_supportManager_addToPool_global
    // so that it has the default amount of uses
    _kiskaSupportInfo = _kiskaSupportInfo select 0;
};

[_kiskaSupportInfo] call KISKA_fnc_supportManager_addToPool_global;
[player,_selectedItemSupportId] call BIS_fnc_removeCommMenuItem;


nil
