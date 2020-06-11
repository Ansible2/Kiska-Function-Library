/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addRespawnEventHandlers

Description:
	Adds the respawn eventHandlers for KISKA's rally point system.
	
	Initialized by KISKA_fnc_initializeRespawnSystem
	
	Called recursively upon respawn

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		
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

			if !(isNil {_actionId}) then {
				_corpse removeAction _actionId;
				missionNamespace setVariable ["KISKA_spawnId",nil];
			};

			_corpse removeEventHandler ["Killed",_thisEventHandler];
		}];

		player addEventHandler ["Respawn", {
			params ["_newUnit"];
			
			private _spawnInfo = missionNamespace getVariable "KISKA_spawnInfo";
			
			if !(isNil {_spawnInfo}) then {
				missionNamespace setVariable ["KISKA_spawnInfo",nil];
				_spawnInfo pushBack _newUnit;
				_spawnInfo call KISKA_fnc_updateRallyAction;
			};

			_newUnit removeEventHandler ["Respawn",_thisEventHandler];

			call KISKA_fnc_addRespawnEventHandlers;
		}];
	}
] call CBA_fnc_waitUntilAndExecute;