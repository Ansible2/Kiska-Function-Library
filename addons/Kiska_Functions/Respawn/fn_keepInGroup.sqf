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
        PRE-INIT function
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_keepInGroup";

if (!hasInterface) exitWith {};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};

if (!canSuspend) exitWith {
    ["Must be run in scheduled",false] call KISKA_fnc_log;
    [] spawn KISKA_fnc_keepInGroup;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

localNamespace setVariable ["KISKA_playerGroup",grpNull];
localNamespace setVariable ["KISKA_team",""];

player addEventHandler ["KILLED", {
    params ["_corpse"];
    // set values player had just before death
    localNamespace setVariable ["KISKA_playerGroup",group _corpse];
    localNamespace setVariable ["KISKA_team",assignedTeam _corpse];
}];

player addEventHandler ["RESPAWN", {
    params ["_unit"];

    private _previousGroup = localNamespace getVariable ["KISKA_playerGroup",grpNull];
    if (
        !isNull _previousGroup AND
        {(group _unit) isNotEqualTo _previousGroup}
    ) then {
        [_unit] joinSilent _previousGroup;

        private _previousTeam = localNamespace getVariable ["KISKA_team",""];
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
