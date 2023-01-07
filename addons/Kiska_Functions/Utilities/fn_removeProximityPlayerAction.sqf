/* ----------------------------------------------------------------------------
Function: KISKA_fnc_removeProximityPlayerAction

Description:
    Stages an action added with KISKA_fnc_addProximityPlayerAction for removal.
    This happens within the loop logic of KISKA_fnc_addProximityPlayerAction so
     it is NOT instant.

Parameters:
	0: _id : <NUMBER> - The proximity action id returned from KISKA_fnc_addProximityPlayerAction

Returns:
	<BOOL> - False if action still exists, true if it does not

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

private _varBase = "KISKA_proximityAction_" + (str _id);
private _actionShouldBeRemovedVar = _varBase + "_remove";
if !(localNamespace getVariable [_actionShouldBeRemovedVar,false]) exitWith {
    localNamespace setVariable [_actionShouldBeRemovedVar,true];
    true
};


false
