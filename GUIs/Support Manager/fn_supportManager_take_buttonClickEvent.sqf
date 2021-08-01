#include "Headers\Support Manager Common Defines.hpp"
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
#define MESSAGE_COLOR [0.75,0,0,1] // red

// support menu only supports a max of ten at a time
private _maxAllowedSupports = missionNamespace getVariable ["KISKA_CBA_supportManager_maxSupports",10];
if (count (player getVariable ["BIS_fnc_addCommMenuItem_menu",[]]) isEqualTo _maxAllowedSupports) then { // make setting
	["You already have the max supports possible"] call KISKA_fnc_errorNotification;

} else {

	private _selectedIndex = lbCurSel (uiNamespace getVariable "KISKA_SM_poolListBox_ctrl");
	if (_selectedIndex isNotEqualTo -1) then {
		private "_supportClass";
		private _useCount = -1;
		private _support = POOL_GVAR select _selectedIndex;

		if (_support isEqualType []) then {
			// adding number of allowed uses
			_supportClass = _support select 0;
			_useCount = _support select 1;
		} else {
			_supportClass = _support;
		};

		// check condition to take
		private _config = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
		private _condition = getText(_config >> "managerCondition");

		// add to player and update list
		if (_condition isEqualTo "" OR {[_supportClass] call (compile _condition)}) then {
			[player,_supportClass,"",_useCount] call KISKA_fnc_addCommMenuItem;
			[_selectedIndex] remoteExecCall ["KISKA_fnc_supportManager_removeFromPool",0,true];
			call KISKA_fnc_supportManager_updateCurrentList;

		} else {
			private _conditionMessage = getText(_config >> "conditionMessage");
			if (_conditionMessage isEqualTo "") then {
				_conditionMessage = DEFAULT_CANT_TAKE_MESSAGE;
			};

			[_conditionMessage] call KISKA_fnc_errorNotification;
		};
	};
};


nil
