/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_updateCurrentList

Description:
	Acts as an event that will update the current trait list of a player in
	 the GUI.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_traitManager_updateCurrentList;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_updateCurrentList";

// check if menu is open
private _listControl = GET_TM_CURRENT_LIST_CTRL;
if (isNull _listControl) exitWith {};

lbClear _listControl;

private ["_trait","_traitValue"];
(getAllUnitTraits player) apply {
    _trait = toUpperANSI (_x select 0);
    _traitValue = _x select 1;

    // don't add Coefficient traits to the list
    if !(_traitValue isEqualType 123) then {
        // default traits are the only bools and if they are true the player has them\
        // custom values are strings
        private _isDefaultTrait = _traitValue isEqualType (true);
        if (!_isDefaultTrait OR {_isDefaultTrait AND _traitValue}) then {
            _listControl lbAdd _trait;
        };
    };
};


nil
