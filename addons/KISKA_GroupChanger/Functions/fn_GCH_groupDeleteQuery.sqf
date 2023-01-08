/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_groupDeleteQuery

Description:
    Acts as a liason from a client to add a group to auto delete if necessary.

    Only works where the group is local and need to use groupOwner to get that
     which only works on the server.

Parameters:
    0: _group <GROUP> - The group to change the auto-deletion on
    1: _canDelete <BOOL> - Set the group to be deleted or not

Returns:
    NOTHING

Examples:
    (begin example)
        [myGroup,false] call KISKA_fnc_GCH_groupDeleteQuery;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_groupDeleteQuery";

if (!isServer) exitWith {
    ["Must be run on server",true] call KISKA_fnc_log;
    nil
};


params ["_group","_canDelete"];

_this remoteExecCall ["deleteGroupWhenEmpty",groupOwner _group];


nil
