#include "..\Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_take_buttonClickEvent

Description:
    Activates when the take button is pressed and gives player the support.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_supportManager_take_buttonClickEvent;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_take_buttonClickEvent";

#define DEFAULT_CANT_TAKE_MESSAGE "You do not have permission for this support"

// support menu only supports a max of ten at a time
private _maxAllowedSupports = missionNamespace getVariable ["KISKA_CBA_supportManager_maxSupports",10];
private _hasMaxSupports = count (player getVariable ["BIS_fnc_addCommMenuItem_menu",[]]) isEqualTo _maxAllowedSupports;
if (_hasMaxSupports) then { 
    ["You already have the max supports possible"] call KISKA_fnc_errorNotification;

} else {
    private _selectedIndex = lbCurSel (GET_SM_POOL_LIST_CTRL);
    if (_selectedIndex isEqualTo -1) exitWith {};

    private "_supportClass";
    private _useCount = -1;
    private _support = SM_POOL_GVAR select _selectedIndex;

    if (_support isEqualType []) then {
        // adding number of allowed uses
        _supportClass = _support select 0;
        _useCount = _support select 1;

    } else {
        _supportClass = _support;

    };

    // searching any config as some might want to add supports in an addon vs missionConfigFile
    private _config = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
    private _condition = getText(_config >> "managerCondition");

    // add to player and update list
    if ((_condition isEqualTo "") OR { [_supportClass] call (compile _condition) }) then {
        [player,_supportClass,"",_useCount] call KISKA_fnc_addCommMenuItem;
        [_selectedIndex] call KISKA_fnc_supportManager_removeFromPool_global;

    } else {
        private _conditionMessage = getText(_config >> "conditionMessage");
        if (_conditionMessage isEqualTo "") then {
            _conditionMessage = DEFAULT_CANT_TAKE_MESSAGE;
        };

        [_conditionMessage] call KISKA_fnc_errorNotification;

    };
};


nil
