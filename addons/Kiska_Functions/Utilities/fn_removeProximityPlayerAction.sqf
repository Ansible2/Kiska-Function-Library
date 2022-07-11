/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addProximityPlayerAction

Description:
    Stages an action added with KISKA_fnc_addProximityPlayerAction for removal.
    This happens within the loop logic of KISKA_fnc_addProximityPlayerAction so
     it is NOT instant.

Parameters:
	0: _id : <NUMBER> - The proximity action id returned from KISKA_fnc_addProximityPlayerAction

Returns:
	<NUMBER> - False if not removed, true if removed

Examples:
    (begin example)
        [0] call KISKA_fnc_removeProximityPlayerAction;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_removeProximityPlayerAction";

params [
    ["_id",-1,[123]]
];

if (_id < 0) exitWith {
    [[_id," is not valid"],true] call KISKA_fnc_log;
    false
};

private _varName = "KISKA_proximityAction_" + (str _id);
if (localNamespace getVariable [_varName,false]) exitWith {
    localNamespace setVariable [_varName,false];
    true
};


false
