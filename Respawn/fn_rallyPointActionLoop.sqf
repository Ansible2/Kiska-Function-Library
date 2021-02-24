/* ----------------------------------------------------------------------------
Function: KISKA_fnc_rallyPointActionLoop

Description:
	Adds a rally point action to the player object. The action is only available
	 to the group leader at that moment. If a player joins a group or is no longer
	 the leader of their group, they gain or lose the action respectively.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		[] spawn KISKA_fnc_rallyPointActionLoop;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_rallyPointActionLoop"
scriptName SCRIPT_NAME;

if (!hasInterface) exitWith {
	["Was run on machine without interface, needs an interface",false] call KISKA_fnc_log;
};

If (!isMultiplayer) exitWith {
	["KISKA rally point system does not run in singlePlayer",true] call KISKA_fnc_log;
};

if (!canSuspend) exitWith {
	["Must run in scheduled environment",true] call KISKA_fnc_log;
};

waitUntil {sleep 2; !isNull player;};


KISKA_fnc_respawn_updateRallyAction = {
	private _playerIsLeader = (leader (group player)) isEqualTo player;

	if (!_playerIsLeader AND {!isNil "KISKA_spawnId"}) exitWith {
		player removeAction KISKA_spawnId;
		KISKA_spawnId = nil;
	};

	if (_playerIsLeader) exitWith {
		if (isNil "KISKA_spawnId") then {
			private _actionId = player addaction [
				"<t color='#4287f5'>Place Rally Point</t>",
				{
					private _caller = param [1];
					private _groupName = missionNamespace getVariable ["KISKA_respawnGroupID",groupId (group _caller)];

					[_caller, ([_groupName,"spawnMarker"] joinString "_"), ([_groupName,"Respawn Beacon"] joinString " ")] remoteExecCall ["KISKA_fnc_updateRespawnMarker",2]; 		

					hint "Rally Point Updated";
				},
				nil,
				1.5,
				false,
				true
			];

			// update global variables
			KISKA_spawnId = _actionId;
		};
	};
};


// event handlers don't seem to properly act as persistent through respawn
/// when attached to the player object, so they are added and removed
//// dynamically.
player addEventHandler ["KILLED", {
	params ["_corpse"];
	
	if (!isNil "KISKA_spawnId") then {
		_corpse removeAction KISKA_spawnId;
		KISKA_spawnId = nil;
	};

	player removeEventHandler ["KILLED",_thisEventHandler];
}];
player addEventHandler ["Respawn", {
	params ["_unit"];
	
	player removeEventHandler ["Respawn",_thisEventHandler];

	[] spawn KISKA_fnc_rallyPointActionLoop;
}];

while {sleep 5; alive player} do {
	call KISKA_fnc_respawn_updateRallyAction;
};