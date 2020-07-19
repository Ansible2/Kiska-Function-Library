if (!hasInterface) exitWith {};

[
	{!isNull player},
	{
		player addEventHandler ["KILLED", {
			params ["_corpse"];

			KISKA_playerGroup = group _corpse;			
		}];

		player addEventHandler ["Respawn", {
			params ["_unit"];
			
			if (!isNull KISKA_playerGroup AND (!((group _unit) isEqualTo KISKA_playerGroup))) then {
				[_unit] joinSilent KISKA_playerGroup;
			};			
		}];
	}
] call CBA_fnc_waitUntilAndExecute;