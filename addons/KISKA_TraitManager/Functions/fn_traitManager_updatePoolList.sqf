#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traittManager_updatePoolList

Description:
	Acts as an event that will update the available traits pool list in
	 the Trait Manager GUI.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_traitManager_updatePoolList;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_updatePoolList";

if !(hasInterface) exitWith {};

disableSerialization;

// check if menu is open
private _poolControl = GET_TM_POOL_LIST_CTRL;
if (isNull _poolControl) exitWith {
	["_poolControl is null!"] call KISKA_fnc_log;
	nil
};

// init to empty array if undefined to allow comparisons
if (isNil TM_POOL_VAR_STR) then {
	missionNamespace setVariable [TM_POOL_VAR_STR,[]];
};
if (TM_POOL_GVAR isEqualTo []) exitWith {
	lbClear _poolControl;
	_poolControl setVariable [TM_DISPLAYED_POOL_VAR_STR,[]];
};


/* ----------------------------------------------------------------------------
    Change Entries
---------------------------------------------------------------------------- */
private _traitPool_displayed = GET_TM_DISPLAYED_POOL;
[[GET_TM_DISPLAY],false] call KISKA_fnc_log;
[[GET_TM_POOL_LIST_CTRL],false] call KISKA_fnc_log;
[[GET_TM_CURRENT_LIST_CTRL],false] call KISKA_fnc_log;

[str _traitPool_displayed,false,true,false] call KISKA_fnc_log;
[str (TM_POOL_GVAR),false,true,false] call KISKA_fnc_log;
// subtracting 1 from this to get indexes
private _countOfDisplayed = (count _traitPool_displayed) - 1;
private ["_trait","_comparedIndex"];
{
	_trait = toUpperANSI _x;
	// instead of clearing the list, we will change entries up until there are more entries in the array then currently in the list
	if (_countOfDisplayed >= _forEachIndex) then {
		// check if entry at index is different and therefore needs to be changed
		_comparedIndex = _traitPool_displayed select _forEachIndex;
		if (_trait != _comparedIndex) then {
			_poolControl lbSetText [_forEachIndex, _trait];
			["1"] call KISKA_fnc_log;
		};

	} else {
		_poolControl lbAdd _trait;
		["2"] call KISKA_fnc_log;
	};

} forEach TM_POOL_GVAR;


// delete overflow indexes that are no longer accurate
private _countOfCurrent = (count TM_POOL_GVAR) - 1;
if (_countOfDisplayed > _countOfCurrent) then {
	private _indexToDelete = _countOfCurrent + 1;
	for "_i" from _countOfCurrent to _countOfDisplayed do {
		// deleting the same index because the tree will move down with each deletetion
		_poolControl lbDelete _indexToDelete;
	};
};
[str _traitPool_displayed,false,true,false] call KISKA_fnc_log;
[str (TM_POOL_GVAR),false,true,false] call KISKA_fnc_log;
// creating a copy of TM_POOL_GVAR so that when changes are made to it, the displayed array will not have those changes and therefore we can compare
_poolControl setVariable [TM_DISPLAYED_POOL_VAR_STR,+TM_POOL_GVAR];
[str (GET_TM_DISPLAYED_POOL),false,true,false] call KISKA_fnc_log;
[str (TM_POOL_GVAR),false,true,false] call KISKA_fnc_log;
