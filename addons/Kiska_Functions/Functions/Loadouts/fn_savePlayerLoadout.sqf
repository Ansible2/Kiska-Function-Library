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
    if !(isNull player) then { breakWith true };
    sleep 1;
    false
};

player addEventHandler ["KILLED", {
    params ["_unit"];

    private _loadout = getUnitLoadout _unit;
    localNamespace setVariable ["KISKA_loadout",_loadout];
    localNamespace setVariable ["KISKA_playersBody",_unit];
}];

player addEventHandler ["RESPAWN", {
    private _doRestoreLoadout = missionNamespace getVariable ["KISKA_CBA_restorePlayerLoadout",false];
    if (_doRestoreLoadout AND !(isNil {localNamespace getVariable "KISKA_loadout"})) then {
        [
            {
                player setUnitLoadout (localNamespace getVariable "KISKA_loadout");
            },
            [],
            0.5
        ] call KISKA_fnc_CBA_waitAndExecute;
    };

    private _doDeleteBody = missionNamespace getVariable ["KISKA_CBA_deleteBody",false];
    private _playerBody = localNamespace getVariable "KISKA_playersBody";
    if (_doDeleteBody AND !(isNil "_playerBody")) then {
        deleteVehicle _playerBody;
    };
}];


nil
