/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_canRallyCombo

Description:
	Adds control event handler to the combo box for turning it on and off.

Parameters:
	0: _control <CONTROL> - The control for the combo box

Returns:
	NOTHING

Examples:
    (begin example)
        [_control] call KISKA_fnc_GCHOnLoad_canRallyCombo;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad_canRallyCombo";

params ["_control"];

_control ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_selectedIndex"];

	private _selectedgroup = [] call KISKA_fnc_GCH_getSelectedGroup;;
	if !(isNull _selectedgroup) then {

		if ([_selectedgroup] call KISKA_fnc_GCH_isAllowedToEdit) then {
			// NO
			if (_selectedIndex isEqualTo 0) then {
				[_selectedgroup,true] remoteExecCall ["KISKA_fnc_disallowGroupRally",2];
			} else {
			// YES
				[_selectedgroup] remoteExecCall ["KISKA_fnc_allowGroupRally",2];
			};
		} else {
			// when selecting a group, and this control is created/updated in the right pane, this error may show for certain users
			// despite not having changed the setting, therefore, this boolean is used to see if this control was just created and this
			// is the second time or more the control is adjusted
			if !(_control getVariable ["KISKA_firstTimeComboChanged",false]) then {
				["You do not have permission to change this setting"] call KISKA_fnc_errorNotification;

			} else {
				_control setVariable ["KISKA_firstTimeComboChanged",false];

			};
		};
	};

}];

_control lbAdd "NO";
_control lbAdd "YES";


nil
