/* ----------------------------------------------------------------------------
Function: KISKA_fnc_removeBISArsenalAction

Description:
	Removes the BIS arsenal action from the given object.

Parameters:
	0: _arsenal <OBJECT> - The arsenal to remove from

Returns:
	<BOOL> - true if arsenal was removed, false if never existed or does not currently exist

Examples:
    (begin example)
		_done = [arsenal] call KISKA_fnc_removeBISArsenalAction;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_removeBISArsenalAction";

params [
    ["_object",objNull,[objNull]]
];

if (isNull _object) exitWith {
    ["_object is null!",true] call KISKA_fnc_log;
    false
};

private _actionId = _object getVariable ["bis_fnc_arsenal_action",-1];
if (_actionId isNotEqualTo -1) exitWith {
    _object removeAction _actionId;
    true
};


false
