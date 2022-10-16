/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_setLeaderRemote

Description:
    Remotely sets a leader of a group from the server. (Must be run on the server)

Parameters:
    0: _group <GROUP> - The group to set the unit to leader
    1: _unitToSet <OBJECT> - The unit to set to leader of the group

Returns:
    NOTHING

Examples:
    (begin example)
    	[group player, player] call KISKA_fnc_GCH_setLeaderRemote;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_setLeaderRemote";

params ["_group","_unitToSet"];

if (!isServer) exitWith {
	["Must be run on server!",true] call KISKA_fnc_log;
	nil
};

_this remoteExecCall ["selectLeader",groupOwner _group];


nil