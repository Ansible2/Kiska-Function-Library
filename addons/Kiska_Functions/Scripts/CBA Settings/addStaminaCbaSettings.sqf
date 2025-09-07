/*
Parameters:
    _setting     - Unique setting name. Matches resulting variable name <STRING>
    _settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    _title       - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
    _category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
    _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY>
    _isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER>
    _script      - Script to execute when setting is changed. (optional) <CODE>
    _needRestart - Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
*/

[
    "KISKA_CBA_enableStamina",
    "CHECKBOX",
    ["Enable Stamina","Turns on or off vanilla stamina system for the player"],
    "KISKA Stamina Settings",
    false,
    0,
    {
        if (!hasInterface) exitWith {};

        _this spawn {
            params ["_setting"];

            waitUntil {
                sleep 1;
                alive player
            };

            player enableStamina _setting;

            private _respawnEventId = localNamespace getVariable ["KISKA_CBA_enableStaminaRespawnEventId",-1];
            if (_respawnEventId isEqualTo -1) then {
                _respawnEventId = player addEventHandler [
                    "RESPAWN",
                    {
                        player enableStamina KISKA_CBA_enableStamina;
                    }
                ];
                localNamespace setVariable ["KISKA_CBA_enableStaminaRespawnEventId",_respawnEventId];
            };
        };
    }
] call CBA_fnc_addSetting;


[
    "KISKA_CBA_walkWeight",
    "SLIDER",
    ["Walk Weight (lbs)","If a player exceeds this weight, they will be forced to walk."],
    "KISKA Stamina Settings",
    [0,200,95,1],
    0,
    {
        if !(hasInterface) exitWith {};

        _this spawn {
            waitUntil {
                sleep 1;
                alive player
            };

            private _perframeId = localNamespace getVariable ["KISKA_CBA_walkWeight_perframeHandlerId",-1];
            if (_perframeId isEqualTo -1) then {
                _perframeId = [
                    {   
                        params ["","_perframeId"];

                        if (KISKA_CBA_walkWeight isEqualTo 0) exitWith {
                            private _paused = localNamespace getVariable ["KISKA_CBA_walkWeight_pause",false];
                            if ((!_paused) AND (isForcedWalk player)) then {
                                player forceWalk false;
                            };

                            localNamespace setVariable ["KISKA_CBA_walkWeight_perframeHandlerId",nil];
                            [_perframeId] call KISKA_fnc_CBA_removePerFrameHandler;
                        };

                        private _paused = localNamespace getVariable ["KISKA_CBA_walkWeight_pause",false];
                        if (!(alive player) OR _paused) exitWith {};

                        private _playerLoadInPounds = (loadAbs player) / 10;
                        if (_playerLoadInPounds < KISKA_CBA_walkWeight) exitWith {
                            if (isForcedWalk player) then {
                                player forceWalk false;
                            };
                        };

                        if (isForcedWalk player) exitWith {};

                        player forceWalk true;
                    },
                    2
                ] call KISKA_fnc_CBA_addPerFrameHandler;

                localNamespace setVariable ["KISKA_CBA_walkWeight_perframeHandlerId",_perframeId];
            };
        };
    }
] call CBA_fnc_addSetting;
