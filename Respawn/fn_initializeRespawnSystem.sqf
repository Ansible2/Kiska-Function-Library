/* ----------------------------------------------------------------------------
Function: KISKA_fnc_initializeRespawnSystem

Description:
	Initializes the respawn system for KISKA. It is the only function that need be called and must be done on the server

	Only works in Multiplayer.

Parameters:
	0: _groupsAndNames : <ARRAY>
		- Player group to add system to <GROUP>
		- Preffed group string name (optional) <STRING>

Returns:
	Nothing

Examples:
    (begin example)

		[[[JTFS_group,"JTFS"]]] call KISKA_fnc_initializeRespawnSystem;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_initializeRespawnSystem";

if (!isMultiplayer OR {!isServer}) exitWith {};

params [
	["_groupsAndNames",[],[[]]]
];


if (_groupsAndNames isEqualTo []) exitWith {};

{
	if !(_x isEqualType []) exitWith {
		[["Index",str _forEachIndex,"is not array!"] joinString " "] call BIS_fnc_error;
	};

	if (_x isEqualTypeParams [grpNull,""] OR {_x isEqualTypeParams [grpNull]}) then {
		
		[	
			missionNamespace,
			"PlayerConnected",
			{
				private _owner = param [4];
				
				// takes a bit of time to sync, this adds some wiggle so the leader of the group has been properly broadcasted
				[
					{
						_this remoteExec ["KISKA_fnc_updateRallyAction",units (_this select 0)];
					},
					_thisArgs,
					3
				] call CBA_fnc_waitAndExecute;
				

				remoteExecCall ["KISKA_fnc_addRespawnEventHandlers",_owner];
			}, 
			_x
		] call CBA_fnc_addBISEventHandler;

		[	
			missionNamespace,
			"PlayerDisconnected",
			{
				[
					{
						_this remoteExec ["KISKA_fnc_updateRallyAction",units (_this select 0)];
					},
					_thisArgs,
					3
				] call CBA_fnc_waitAndExecute;
			}, 
			_x
		] call CBA_fnc_addBISEventHandler;

	};

} forEach _groupsAndNames;