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

	private _selectedgroup = uiNamespace getVariable ["KISKA_GCH_selectedGroup",grpNull];
	if !(isNull _selectedgroup) then {

		if ([_selectedgroup] call KISKA_fnc_GCH_isAllowedToEdit) then {
			// NO
			if (_selectedIndex isEqualTo 0) then {
				[_selectedgroup,true] remoteExecCall ["KISKA_fnc_disallowGroupRally"];
			} else {
			// YES
				[_selectedgroup] remoteExecCall ["KISKA_fnc_allowGroupRally"];
			};
		} else {
			[["Error",1.1,[0.75,0,0,1]],"You do not have permission to change this setting",false] call CBA_fnc_notify;
		};
	};
}];

_control lbAdd "NO";
_control lbAdd "YES";


nil
