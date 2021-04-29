/* ----------------------------------------------------------------------------
Function: KISKA_fnc_keepInGroup

Description:
	Attempts to keep a player in the same group and team after they respawn.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		POST-INIT function
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_keepInGroup";

if (!hasInterface) exitWith {};

waitUntil {
	sleep 0.1;
	!isNull player
};

missionNamespace setVariable ["KISKA_playerGroup",grpNull];
missionNamespace setVariable ["KISKA_team",""];

player addEventHandler ["KILLED", {
	params ["_corpse"];

	missionNamespace setVariable ["KISKA_playerGroup",group _corpse];
	missionNamespace setVariable ["KISKA_team",assignedTeam _corpse];
}];

player addEventHandler ["RESPAWN", {
	params ["_unit"];

	private _previousGroup = missionNamespace getVariable ["KISKA_playerGroup",grpNull];
	if (
		!isNull _previousGroup AND
		{(group _unit) isNotEqualTo _previousGroup}
	) then {
		[_unit] joinSilent _previousGroup;

		private _previousTeam = missionNamespace getVariable ["KISKA_team",""];
		if (
			_previousTeam isNotEqualTo "" AND
			{_previousTeam isNotEqualTo "MAIN"}
		) then {
			[_unit,_previousTeam] spawn {
				(_this select 0) assignTeam (_this select 1);
			};
		};
	};
}];


nil
