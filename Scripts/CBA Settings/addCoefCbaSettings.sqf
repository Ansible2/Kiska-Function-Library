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
    "KISKA_CBA_weaponSwayCoef",
    "SLIDER",
    ["Weapon Sway","100% equals most sway possible"],
    ["KISKA Coefficient Settings","Weapons"],
    [0,1,0.15,2,true],
    0,
    {
        params ["_value"];

        player setCustomAimCoef _value;

        if (isNil "KISKA_weaponSwayRespawnEvent_id") then {
            private _id = player addEventHandler ["RESPAWN",{
                player setCustomAimCoef KISKA_CBA_weaponSwayCoef;
            }];

            missionNamespace setVariable ["KISKA_weaponSwayRespawnEvent_id",_id];
        };
    }
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_recoilCoef",
    "SLIDER",
    ["Recoil Strength","100% equals the most recoil"],
    ["KISKA Coefficient Settings","Weapons"],
    [0,1,0.5,2,true],
    0,
    {
        params ["_value"];

        player setUnitRecoilCoefficient _value;

        if (isNil "KISKA_recoilCoefRespawnEvent_id") then {
            private _id = player addEventHandler ["RESPAWN",{
                player setUnitRecoilCoefficient KISKA_CBA_recoilCoef;
            }];

            missionNamespace setVariable ["KISKA_recoilCoefRespawnEvent_id",_id];
        };
    }
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_loadCoef",
    "SLIDER",
    ["Load Coefficient","How much the weight of a player's equipment affects fatigue. Higher means has more of an effect."],
    ["KISKA Coefficient Settings","Traits"],
    [0.1,3,1,1,false],
    0,
    {
        params ["_value"];

        player setUnitTrait ["loadCoef", _value];

        if (isNil "KISKA_loadCoefRespawnEvent_id") then {
            private _id = player addEventHandler ["RESPAWN",{
                player setUnitTrait ["loadCoef", KISKA_CBA_loadCoef];
            }];

            missionNamespace setVariable ["KISKA_loadCoefRespawnEvent_id",_id];
        };
    }
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_audibleCoef",
    "SLIDER",
    ["Audible Coefficient","How easy an AI unit can hear players. Higher means easier."],
    ["KISKA Coefficient Settings","Traits"],
    [0.1,3,1,1,false],
    0,
    {
        params ["_value"];

        player setUnitTrait ["audibleCoef", _value];

        if (isNil "KISKA_audibleCoefRespawnEvent_id") then {
            private _id = player addEventHandler ["RESPAWN",{
                player setUnitTrait ["audibleCoef", KISKA_CBA_audibleCoef];
            }];

            missionNamespace setVariable ["KISKA_audibleCoefRespawnEvent_id",_id];
        };
    }
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_camouflageCoef",
    "SLIDER",
    ["Camouflage Coefficient","How easy an AI unit can spot players. Higher means easier."],
    ["KISKA Coefficient Settings","Traits"],
    [0.1,3,1,1,false],
    0,
    {
        params ["_value"];

        player setUnitTrait ["camouflageCoef ", _value];

        if (isNil "KISKA_camouflageCoefRespawnEvent_id") then {
            private _id = player addEventHandler ["RESPAWN",{
                player setUnitTrait ["camouflageCoef", KISKA_CBA_camouflageCoef];
            }];

            missionNamespace setVariable ["KISKA_camouflageCoefRespawnEvent_id",_id];
        };
    }
] call CBA_fnc_addSetting;