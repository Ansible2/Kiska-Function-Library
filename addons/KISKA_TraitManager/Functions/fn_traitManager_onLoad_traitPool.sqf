#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_onLoad_traitPool

Description:
	Begins the loop that syncs across the network and populates the pool list.

Parameters:
	0: _display <DISPLAY> - The loaded display of the trait manager

Returns:
	NOTHING

Examples:
    (begin example)
		// called from config
		[_display] spawn KISKA_fnc_traitManager_onLoad_traitPool;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_onLoad_traitPool";

#define REFRESH_SPEED (missionNamespace getVariable ["KISKA_CBA_traitManager_updateFreq",0.5])

if (!canSuspend) exitWith {
	_this spawn KISKA_fnc_traitManager_onLoad_traitPool;
};

params ["_display"];

private _poolControl = uiNamespace getVariable "KISKA_TM_poolListBox_ctrl";

// init to empty array if undefined to allow comparisons
if (isNil TM_POOL_VAR_STR) then {
	missionNamespace setVariable [TM_POOL_VAR_STR,[]];
};

private _fn_updateTraitPoolList = {

	if (POOL_GVAR isEqualTo []) exitWith {
		lbClear _poolControl;
	};

	// subtracting 1 from these to get indexes
	private _countOfDisplayed = (count _traitPool_displayed) - 1;
	private _countOfCurrent = (count TM_POOL_GVAR) - 1;

	private "_trait";
	{
		_trait = toUpperANSI _x;
		// instead of clearing the list, we will change entries up until there are more entries in the array then currently in the list
		if (_countOfDisplayed >= _forEachIndex) then {
			// check if entry at index is different and therefore needs to be changed
			_comparedIndex = _traitPool_displayed select _forEachIndex;
			if (_trait != _comparedIndex) then {
				_poolControl lbSetText [_forEachIndex, _trait];
			};
		} else {
			_poolControl lbAdd _trait;
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
};

private _traitPool_displayed = [];
while {sleep REFRESH_SPEED; !(isNull _display)} do {

	// support pool check
	if (_traitPool_displayed isNotEqualTo TM_POOL_GVAR) then {
		call _fn_updateTraitPoolList;
		_traitPool_displayed = +TM_POOL_GVAR;
	};
};


nil
