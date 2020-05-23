/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addRespawnEventHandlers

Description:
	Adds the respawn eventHandlers for KISKA's rally point system

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		Initialized by KISKA_fnc_initializeRespawnSystem
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */


if !(isMultiplayer OR {!hasInterface}) exitWith {};

[
	{!isNull player},
	{
		player addEventHandler ["Killed", {
			params ["_corpse"];
			
			private _actionId = missionNamespace getVariable "KISKA_spawnId";
			missionNamespace setVariable ["KISKA_spawnId",nil];

			if !(isNil {_actionId}) then {
				_corpse removeAction _actionId;
			};
		}];

		player addEventHandler ["Respawn", {
			params ["_newUnit"];
			
			private _spawnInfo = missionNamespace getVariable "KISKA_spawnInfo";
			missionNamespace setVariable ["KISKA_spawnInfo",nil];
			
			if !(isNil {_spawnInfo}) then {
				_spawnInfo pushBack _newUnit;
				_spawnInfo call KISKA_fnc_updateRallyAction;
			};
		}];
	}
] call CBA_fnc_waitUntilAndExecute;