#include "Headers\Support Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_updateCurrentList

Description:
	Acts as an event that will update the current supports list of a player in
	 the GUI.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_supportManager_updateCurrentList;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_updateCurrentList";

if !(hasInterface) exitWith {};

disableSerialization;

private _listControl = GET_SM_CURRENT_LIST_CTRL;
if (isNull _listControl) exitWith {};


lbClear _listControl;
if (!(isNil "KISKA_playersSupportMap") AND {count KISKA_playersSupportMap > 0}) then {

	private ["_config","_text","_class","_toolTip","_path","_icon"];
	private _usedIconColor = missionNamespace getVariable ["KISKA_CBA_supportManager_usedIconColor",[0.75,0,0,1]];
	KISKA_playersSupportMap apply {

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
			_listControl lbSetPictureColor [_path,_usedIconColor];
			_listControl lbSetPictureColorSelected [_path,_usedIconColor];
		};

	};

};


nil
