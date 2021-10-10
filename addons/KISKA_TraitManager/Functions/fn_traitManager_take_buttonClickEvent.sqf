#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_take_buttonClickEvent

Description:
	Activates when the take button is pressed and gives player the trait

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_traitManager_take_buttonClickEvent;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_traitManager_take_buttonClickEvent";

#define RESERVED_TRAITS ["MEDIC","ENGINEER","EXPLOSIVESPECIALIST","UAVHACKER"]
#define DEFAULT_ERROR_MESSAGE "You do not have permission for this trait"

private _selectedIndex = lbCurSel (uiNamespace getVariable "KISKA_TM_poolListBox_ctrl");
if (_selectedIndex isNotEqualTo -1) then {

	private _trait = toUpperANSI (POOL_GVAR select _selectedIndex);
	if !(player getUnitTrait _trait) then {
		// check condition to take
		private _config = [["KISKA_cfgTraits",_trait]] call KISKA_fnc_findConfigAny;
	    private _condition = "";
	    if !(isNull _config) then {
		   _condition = getText(_config >> "managerCondition");
	    };

		// add to player and update list
		if (_condition isEqualTo "" OR {[_trait] call (compile _condition)}) then {
			private _isCustomTrait = !(_trait in RESERVED_TRAITS);
	        player setUnitTrait [_trait,true,_isCustomTrait];

			[_selectedIndex] remoteExecCall ["KISKA_fnc_traitManager_removeFromPool",0,true];
			call KISKA_fnc_traitManager_updateCurrentList;

		} else {
			private _message = getText(_config >> "errorMessage");
			if (_message isEqualTo "") then {
				_message = DEFAULT_ERROR_MESSAGE;
			};

			[_message] call KISKA_fnc_errorNotification;

		};
	} else {
		["You already have this trait"] call KISKA_fnc_errorNotification;
	};
};


nil
