if (!hasInterface) exitWith {};

[
	{!isNull player},
	{
		player addEventHandler ["KILLED", {
			params ["_corpse"];

			KISKA_playerGroup = group _corpse;
			KISKA_team = assignedTeam _corpse;			
		}];

		player addEventHandler ["Respawn", {
			params ["_unit"];
			
			if (!isNull KISKA_playerGroup AND (!((group _unit) isEqualTo KISKA_playerGroup))) then {
				[_unit] joinSilent KISKA_playerGroup;
				
				if (KISKA_team != "" AND {KISKA_team != "MAIN"}) then {
					null = [_unit] spawn {
						(_this select 0) assignTeam KISKA_team;
					};
				};
			};			
		}];
	}
] call CBA_fnc_waitUntilAndExecute;