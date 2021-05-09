/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_store_buttonClickEvent

Description:
	Activates when the take button is pressed and gives player the support.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_supportManager_store_buttonClickEvent;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_supportManager_store_buttonClickEvent";

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
	
	[_support] call KISKA_fnc_supportManager_addToPool;
	[player,_menuId] call BIS_fnc_removeCommMenuItem;

	call KISKA_fnc_supportManager_updateCurrentList;
};
