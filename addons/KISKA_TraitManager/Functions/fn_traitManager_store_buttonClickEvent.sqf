#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_store_buttonClickEvent

Description:
    Activates when the take button is pressed and gives player the support.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_traitManager_store_buttonClickEvent;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_store_buttonClickEvent";

private _currentListbox_ctrl = GET_TM_CURRENT_LIST_CTRL;
private _selectedIndex = lbCurSel _currentListbox_ctrl;

if (_selectedIndex isNotEqualTo -1) then {
    private _trait = _currentListbox_ctrl lbText _selectedIndex;
    private _isCustomTrait = !(_trait in RESERVED_TRAITS);
    player setUnitTrait [_trait,false,_isCustomTrait];

    [_trait] call KISKA_fnc_traitManager_addToPool_global;
};
