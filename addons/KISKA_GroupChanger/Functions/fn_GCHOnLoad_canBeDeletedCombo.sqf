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
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad_canBeDeletedCombo";

if !(hasInterface) exitWith {};

params ["_control"];

_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	if (call KISKA_fnc_isAdminOrHost) then {

		private _selectedgroup = [] call KISKA_fnc_GCH_getSelectedGroup;;

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
		// when selecting a group, and this control is created/updated in the right pane, this error may show for certain users
		// despite not having changed the setting, therefore, this boolean is used to see if this control was just created and this
		// is the second time or more the control is adjusted
		if !(_control getVariable ["KISKA_firstTimeComboChanged",false]) then {
			["You must be the admin or host to change this setting"] call KISKA_fnc_errorNotification;

		} else {
			_control setVariable ["KISKA_firstTimeComboChanged",false];

		};
	};
}];

_control lbAdd "NO";
_control lbAdd "YES";


nil
