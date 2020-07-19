If (!isMultiplayer) exitWith {
	"KISKA rally point system does not run in singlePlayer" call BIS_fnc_error;
};

if (!canSuspend) exitWith {
	"Must run in scheduled environment" call BIS_fnc_error;
};

waitUntil {sleep 2; !isNull player;};


KISKA_fnc_updateRallyAction2 = {
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

					[_caller, ([_groupName,"spawnMarker"] joinString "_"), ([_groupName,"Respawn Beacon"] joinString " ")] remoteExec ["KISKA_fnc_updateRespawnMarker",2]; 		

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

	null = [] spawn KISKA_fnc_rallyPointActionLoop;
}];

while {alive player} do {
	call KISKA_fnc_updateRallyAction2;

	sleep 5;
};