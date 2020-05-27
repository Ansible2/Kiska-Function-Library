if (!hasInterface) exitWith {
	diag_log "KISKA_fnc_saveLoadouts will only run on those with interfaces";
};

[
	{!isNull player}
	{
		player addEventHandler ["Killed", {
			params ["_unit"];

			KISKA_loadout = getUnitLoadout _unit;
		}];
	}
] call CBA_fnc_waitUntilAndExecute;