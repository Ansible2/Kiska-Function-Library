/* ----------------------------------------------------------------------------
Function: KISKA_fnc_savePlayerLoadout

Description:
    Adds a kill and respawn eventhandler to the player object that restores
     saves and restores the player loadout (if set in CBA menu settings).

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
scriptName "KISKA_fnc_savePlayerLoadout";

if (!hasInterface) exitWith {};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};

if (!canSuspend) exitWith {
    ["Must be run in scheduled",false] call KISKA_fnc_log;
    [] spawn KISKA_fnc_savePlayerLoadout;
};

waitUntil {
    if !(isNull player) exitWith {true};
    sleep 0.1;
    false
};

player addEventHandler ["KILLED", {
    params ["_unit"];

    private _loadout = getUnitLoadout _unit;
    missionNamespace setVariable ["KISKA_loadout",_loadout];
    missionNamespace setVariable ["KISKA_playersBody",_unit];
}];

player addEventHandler ["RESPAWN", {
    if (!isNil "KISKA_loadout" AND {missionNamespace getVariable ["KISKA_CBA_restorePlayerLoadout",false]}) then {
        player setUnitLoadout (missionNamespace getVariable "KISKA_loadout");

        if (missionNamespace getVariable ["KISKA_CBA_deleteBody",false] AND {!isNil "KISKA_playersBody"}) then {
            deleteVehicle (missionNamespace getVariable "KISKA_playersBody");
        };
    };
}];


nil
