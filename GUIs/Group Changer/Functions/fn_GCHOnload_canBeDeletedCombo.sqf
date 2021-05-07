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
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad_canBeDeletedCombo";

params ["_control"];

_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	if (call KISKA_fnc_isAdminOrHost) then {

		private _selectedgroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];

		if !(isNull _selectedgroup) then {

			private _canDelete = isGroupDeletedWhenEmpty _selectedgroup;
			private _fn_setGroupAutoDelete = {
				params ["_allowDelete"];

				if (local _selectedgroup) then {
					_selectedgroup deleteGroupWhenEmpty _allowDelete;
				} else {
					[_selectedgroup, _allowDelete] remoteExecCall ["KISKA_fnc_GCH_groupDeleteQuery",2];
				};
			};


			if (_selectedIndex isEqualTo 0) then {
				// if you can delete the group, set to false
				if (_canDelete) then {
					[false] call _fn_setGroupAutoDelete;
				};
			} else {
				// If you can't delete the group, set to true
				if !(_canDelete) then {
					[true] call _fn_setGroupAutoDelete;
				};
			};
		};
	} else {
		[["Error",1.1,[0.75,0,0,1]],"You must be the admin or host to change this setting",false] call CBA_fnc_notify;
	};
}];

_control lbAdd "NO";
_control lbAdd "YES";


nil
