#include "..\Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_updatePoolList

Description:
	Acts as an event that will update the available supports pool list in
	 the Support Manager GUI.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_supportManager_updatePoolList;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_updatePoolList";

if !(hasInterface) exitWith {};

disableSerialization;

private _poolControl = GET_SM_POOL_LIST_CTRL;
if (isNull _poolControl) exitWith {};

if (isNil SM_POOL_VAR_STR) then {
	missionNamespace setVariable [SM_POOL_VAR_STR,[]];
};
if (SM_POOL_GVAR isEqualTo []) exitWith {
	lbClear _poolControl;
	_poolControl setVariable [SM_DISPLAYED_POOL_VAR_STR,[]];
};



private _configHash = createHashMap;
private ["_displayText","_comparedIndex","_config","_comMenuClass","_path","_toolTip","_icon"];
/* ----------------------------------------------------------------------------
    _fn_setText
---------------------------------------------------------------------------- */
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

/* ----------------------------------------------------------------------------
    _fn_adjustCurrentEntry
---------------------------------------------------------------------------- */
private _usedIconColor = missionNamespace getVariable ["KISKA_CBA_supportManager_usedIconColor",[0.75,0,0,1]];
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



/* ----------------------------------------------------------------------------
    Change Entries
---------------------------------------------------------------------------- */
private _supportPool_displayed = GET_SM_DISPLAYED_POOL;
// subtracting 1 from this to get indexes
private _countOfDisplayed = (count _supportPool_displayed) - 1;
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

} forEach SM_POOL_GVAR;

// delete overflow indexes that are no longer accurate
private _countOfCurrent = (count SM_POOL_GVAR) - 1;
if (_countOfDisplayed > _countOfCurrent) then {
	private _indexToDelete = _countOfCurrent + 1;
	for "_i" from _countOfCurrent to _countOfDisplayed do {
		// deleting the same index because the tree will move down with each deletetion
		_poolControl lbDelete _indexToDelete;
	};
};

_poolControl setVariable [SM_DISPLAYED_POOL_VAR_STR,+SM_POOL_GVAR];
