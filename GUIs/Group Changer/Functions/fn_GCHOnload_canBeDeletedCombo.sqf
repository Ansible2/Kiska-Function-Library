/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_canBeDeletedCombo

Description:
	Adds control event handler to the combo box for turning it on and off.

Parameters:
	0: _control <CONTROL> - The control for the combo box

Returns:
	NOTHING

Examples:
    (begin example)
        [_control] call KISKA_fnc_GCHOnLoad_canBeDeletedCombo;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_GCHOnLoad_canBeDeletedCombo"
scriptName SCRIPT_NAME;

params ["_control"];

_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	if (call KISKA_fnc_isAdminOrHost) then {

		private _selectedgroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];
		
		if !(isNull _selectedgroup) then {
			
			private _canDelete = isGroupDeletedWhenEmpty _selectedgroup;
			private _fn_setGroupAutoDelete = {
				if (local _group) then {
					_group deleteGroupWhenEmpty _canDelete;
				} else {
					[_group, _canDelete] remoteExecCall ["KISKA_fnc_GCH_groupDeleteQuery",2];
				};
			};
			

			if (_selectedIndex isEqualTo 0) then {
				// if not already set to be exempt from auto-deletion
				if (_canDelete) then {
					call _fn_setGroupAutoDelete;
				};
			} else {
				// if not already set to not be auto-deleted
				if !(_canDelete) then {
					call _fn_setGroupAutoDelete;
				};
			};
		};
	} else {
		hint "You must be the admin or host to change this setting";
	};
}];

_control lbAdd "NO";
_control lbAdd "YES";