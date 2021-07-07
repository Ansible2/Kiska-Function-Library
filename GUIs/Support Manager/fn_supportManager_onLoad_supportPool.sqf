#include "Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_onLoad_supportPool

Description:
	Begins the loop that syncs across the network and populates the pool list.

Parameters:
	0: _display <DISPLAY> - The loaded display of the support manager

Returns:
	NOTHING

Examples:
    (begin example)
		// called from config
		[_display] spawn KISKA_fnc_supportManager_onLoad_supportPool;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_supportManager_onLoad_supportPool";

#define REFRESH_SPEED (missionNamespace getVariable ["KISKA_CBA_supportManager_updateFreq",0.5])

if (!canSuspend) exitWith {
	_this spawn KISKA_fnc_supportManager_onLoad_supportPool;
};


params ["_display"];

private _poolControl = uiNamespace getVariable "KISKA_SM_poolListBox_ctrl";

// init to empty array if undefined to allow comparisons
if (isNil TO_STRING(POOL_GVAR)) then {
	missionNamespace setVariable [TO_STRING(POOL_GVAR),[]];
};

private _usedIconColor = missionNamespace getVariable ["KISKA_CBA_supportManager_usedIconColor",[0.75,0,0,1]];
private _fn_updateSupportPoolList = {

	if (POOL_GVAR isEqualTo []) exitWith {
		lbClear _poolControl;
	};

	// subtracting 1 from these to get indexes
	private _countOfDisplayed = (count _supportPool_displayed) - 1;
	private _countOfCurrent = (count POOL_GVAR) - 1;

	private _configHash = createHashMap;

	private ["_displayText","_comparedIndex","_config","_comMenuClass","_path","_toolTip","_icon"];
	private _fn_setText = {
		if (_comMenuClass in _configHash) then {
			_config = _configHash get _comMenuClass;
		} else {
			_config = [["CfgCommunicationMenu",_comMenuClass]] call KISKA_fnc_findConfigAny;
			_configHash set [_comMenuClass,_config];
		};

		_icon = getText(_config >> "icon");
		_displayText = getText(_config >> "text");
		_toolTip = getText(_config >> "tooltip");
	};

	private _fn_adjustCurrentEntry = {
		// entries that are arrays will be ["classname",NumberOfUsesLeft]
		// some supports have multiple uses in them, this keeps track of that if someone stores a
		// multi-use one after having already used it.
		if (_comMenuClass isEqualType []) then {
			_poolControl lbSetValue [_path,(_comMenuClass select 1)];
			// if support was used
			_poolControl lbSetPictureColor [_path,_usedIconColor];
			_poolControl lbSetPictureColorSelected [_path,_usedIconColor];
			_comMenuClass = (_comMenuClass select 0);
		} else {
			// set to default value of zero if entry was not already there
			if ((_poolControl lbValue _path) isNotEqualTo 0) then {
				_poolControl lbSetValue [_path,0];
			};
		};
		_poolControl lbSetData [_path,_comMenuClass];
		call _fn_setText;
		_poolControl lbSetTooltip [_path,_toolTip];
		_poolControl lbSetText [_path,_displayText];
		_poolControl lbSetPicture [_path,_icon];
	};

	{
		_comMenuClass = _x;
		// instead of clearing the list, we will change entries up until there are more entries in the array then currently in the list
		if (_countOfDisplayed >= _forEachIndex) then {
			// check if entry at index is different and therefore needs to be changed
			_comparedIndex = _supportPool_displayed select _forEachIndex;
			if (_comMenuClass isNotEqualTo _comparedIndex) then {
				_path = _forEachIndex;
				call _fn_adjustCurrentEntry;
			};
		} else {
			_path = _poolControl lbAdd "";
			call _fn_adjustCurrentEntry;
		};
	} forEach POOL_GVAR;


	// delete overflow indexes that are no longer accurate
	private _countOfCurrent = (count POOL_GVAR) - 1;
	if (_countOfDisplayed > _countOfCurrent) then {
		private _indexToDelete = _countOfCurrent + 1;
		for "_i" from _countOfCurrent to _countOfDisplayed do {
			// deleting the same index because the tree will move down with each deletetion
			_poolControl lbDelete _indexToDelete;
		};
	};
};



private _supportPool_displayed = [];
while {sleep REFRESH_SPEED; !(isNull _display)} do {

	// support pool check
	if (_supportPool_displayed isNotEqualTo POOL_GVAR) then {
		call _fn_updateSupportPoolList;
		_supportPool_displayed = +POOL_GVAR;
	};
};
