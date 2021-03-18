#include "Support Manager Common Defines.hpp"
#define TO_STRING(NAME_OF) #NAME_OF
#define POOL_GVAR KISKA_SM_pool


KISKA_fnc_supportManager_onLoad = {
	params ["_display"];
	uiNamespace setVariable ["KISKA_sm_display",_display];
	
	uiNamespace setVariable ["KISKA_SM_poolListBox_ctrl",_display displayCtrl SM_POOL_LISTBOX_IDC];
	[_display] spawn KISKA_fnc_supportManager_onLoad_supportPool;

	uiNamespace setVariable ["KISKA_SM_currentListBox_ctrl",_display displayCtrl SM_CURRENT_LISTBOX_IDC];
	[_display] call KISKA_fnc_supportManager_updateCurrentList;

	[_display] call KISKA_fnc_supportManager_onLoad_buttons;

	_display displayAddEventHandler ["unload",{
		uiNamespace setVariable ["KISKA_sm_display",nil];
		uiNamespace setVariable ["KISKA_SM_poolListBox_ctrl",nil];
		uiNamespace setVariable ["KISKA_SM_currentListBox_ctrl",nil];
	}];
};

KISKA_fnc_supportManager_onLoad_supportPool = {
	params ["_display"];
	
	private _poolControl = uiNamespace getVariable "KISKA_SM_poolListBox_ctrl";

	// init to empty array if undefined to allow comparisons
	if (isNil TO_STRING(POOL_GVAR)) then {
		missionNamespace setVariable [TO_STRING(POOL_GVAR),[]];
	};

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
				_listControl lbSetPictureColor [_path,[0.75,0,0,1]]; // test to see if this will work if changing picture after
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
	while {sleep 0.5; !(isNull _display)} do {

		// support pool check
		if (_supportPool_displayed isNotEqualTo POOL_GVAR) then {		
			call _fn_updateSupportPoolList;
			_supportPool_displayed = +POOL_GVAR;
		};
	};
};

KISKA_fnc_supportManager_onLoad_buttons = {
	params ["_display"];
	//[["DATALINK",1.1,[0.75,0,0,1]],_message,false] call CBA_fnc_notify;
	(_display displayCtrl SM_TAKE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
		call KISKA_fnc_supportManager_take_buttonClickEvent;
	}];

	(_display displayCtrl SM_STORE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
		call KISKA_fnc_supportManager_store_buttonClickEvent;
	}];

	(_display displayCtrl SM_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
		(uiNamespace getVariable "KISKA_sm_display") closeDisplay 2;
	}];
};

KISKA_fnc_supportManager_take_buttonClickEvent = {
	if (count (player getVariable ["BIS_fnc_addCommMenuItem_menu",[]]) isEqualTo 10) then {
		[["Error",1.1,[0.75,0,0,1]],"You already have the max supports possible",false] call CBA_fnc_notify;
	} else {
		private _selectedIndex = lbCurSel (uiNamespace getVariable "KISKA_SM_poolListBox_ctrl");
		if (_selectedIndex isNotEqualTo -1) then {
			private _support = POOL_GVAR select _selectedIndex;
			if (_support isEqualType []) then {
				// adding number of allowed uses
				[player,_support select 0,"",_support select 1] call KISKA_fnc_addCommMenuItem;
			} else {
				[player,_support] call KISKA_fnc_addCommMenuItem;
			};

			[_selectedIndex] remoteExecCall ["KISKA_fnc_supportManager_removeFromPool",(call CBA_fnc_players),true];

			call KISKA_fnc_supportManager_updateCurrentList;
		};
	};
};

KISKA_fnc_supportManager_store_buttonClickEvent = {
	private _selectedIndex = lbCurSel (uiNamespace getVariable "KISKA_SM_currentListBox_ctrl");

	if (_selectedIndex isNotEqualTo -1) then {
		private _menuArray = player getVariable ["BIS_fnc_addCommMenuItem_menu",[]];
		private _supportArray = _menuArray select _selectedIndex;
		private _menuId = _supportArray select 0;
		private _support = KISKA_supportHash deleteAt _menuId;

		// if support number of uses is default amount
		if ((_support select 1) isEqualTo -1) then {
			_support = _support select 0;
		};
		[_support] remoteExecCall ["KISKA_fnc_supportManager_addToPool",(call CBA_fnc_players),true];
		[player,_menuId] call BIS_fnc_removeCommMenuItem;

		call KISKA_fnc_supportManager_updateCurrentList;
	};
};

KISKA_fnc_supportManager_updateCurrentList = {
	private _listControl = uiNamespace getVariable "KISKA_SM_currentListBox_ctrl";
	if (!isNil "KISKA_supportHash" AND {count KISKA_supportHash > 0}) then {
		private ["_config","_text","_class","_toolTip","_path","_icon"];
		{
			_class = _y select 0;
			_config = [["cfgCommunicationMenu",_class]] call KISKA_fnc_findConfigAny;
			_toolTip = getText(_config >> "tooltip"); 
			_text = getText(_config >> "text");
			_icon = getText(_config >> "icon");
			
			_path = _listControl lbAdd _text;
			_listControl lbSetTooltip [_path,_toolTip];
			_listControl lbSetPicture [_path,_icon];
			// if support was used
			if ((_y select 1) isNotEqualTo -1) then {
				_listControl lbSetPictureColor [_path,[0.75,0,0,1]];			
			};
		} forEach KISKA_supportHash;
	} else {
		lbClear _listControl;
	};
};

KISKA_fnc_supportManager_removeFromPool = {
	if (!hasInterface) exitWith {};

	params ["_index"];

	private _array = missionNamespace getVariable [TO_STRING(POOL_GVAR),[]];
	if (_array isNotEqualTo []) then {
		_array deleteAt _index;
	};
};

KISKA_fnc_supportManager_addToPool = {
	if (!hasInterface) exitWith {};

	params [
		["_entryToAdd","",["",[]]]
	];

	if (_entryToAdd isEqualTo "" OR {_entryToAdd isEqualTo []}) exitWith {
		["_entryToAdd is empty!",true] call KISKA_fnc_log;
		nil
	};

	// verify class is defined
	private "_class";
	if (_entryToAdd isEqualType []) then {
		_class = _entryToAdd select 0;
	} else {
		_class = _entryToAdd;
	};

	private _config = [["CfgCommunicationMenu",_class]] call KISKA_fnc_findConfigAny;
	if (isNull _config) exitWith {
		[[_class," is not defined in any CfgCommunicationMenu!"],true] call KISKA_fnc_log;
		nil
	};

	[TO_STRING(POOL_GVAR),_entryToAdd] call KISKA_fnc_pushBackToArray;
};
