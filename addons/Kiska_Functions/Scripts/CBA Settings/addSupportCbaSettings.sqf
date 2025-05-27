/*
[
    "Commy_ViewDistance", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    "View Distance", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "My Mission Settings", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [200, 15000, 5000, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
        setViewDistance _value;
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;


Parameters:
    _setting     - Unique setting name. Matches resulting variable name <STRING>
    _settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    _title       - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
    _category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
    _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY>
    _isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER>
    _script      - Script to execute when setting is changed. (optional) <CODE>
    _needRestart - Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>




[
    "",
    "",
    "",
    "",
    [200, 15000, 5000, 0],
    nil,
    {
        params ["_value"];

    }
] call CBA_fnc_addSetting;

*/




// artillery notifications
[
    "KISKA_CBA_suppNotif_arty",
    "LIST",
    ["Artillery Notifications","If calling in support, player will receive a notification for a completed request"],
    ["KISKA Support Settings","Notifications"],
    [
        [0,1,2,3],
        ["None","Radio Notification","Text Notification","Both"],
        1
    ],
    0
] call CBA_fnc_addSetting;
// CAS notifications
[
    "KISKA_CBA_suppNotif_cas",
    "LIST",
    ["CAS Notifications","If calling in support, player will receive a notification for a completed request"],
    ["KISKA Support Settings","Notifications"],
    [
        [0,1,2,3],
        ["None","Radio Notification","Text Notification","Both"],
        1
    ],
    0
] call CBA_fnc_addSetting;
// Heli CAS notifications
[
    "KISKA_CBA_suppNotif_heliCas",
    "LIST",
    ["Helicopter CAS Notifications","If calling in support, player will receive a notification for a completed request"],
    ["KISKA Support Settings","Notifications"],
    [
        [0,1,2,3],
        ["None","Radio Notification","Text Notification","Both"],
        1
    ],
    0
] call CBA_fnc_addSetting;
// supply drop notifications
[
    "KISKA_CBA_suppNotif_supplyDrop",
    "LIST",
    ["Supply Drop Notifications","If calling in support, player will receive a notification for a completed request"],
    ["KISKA Support Settings","Notifications"],
    [
        [0,1,2,3],
        ["None","Radio Notification","Text Notification","Both"],
        1
    ],
    0
] call CBA_fnc_addSetting;





[
    "KISKA_CBA_supp_radiuses",
    "EDITBOX",
    ["Default Artillery Radiuses","When calling for supports with an unspecified set of radiuses to choose, these will be selectable (meters). The minimum is 25m"],
    ["KISKA Support Settings","Support Parameters"],
    ["[25,50,100,250]"],
    0,
    {
        params ["_value"];

        if (_value isEqualTo "") exitWith {
            missionNamespace setVariable ["KISKA_CBA_supp_radiuses","[10,25,50,100,250]"];
        };

        missionNamespace setVariable ["KISKA_CBA_supp_radiuses_arr",parseSimpleArray _value];
    }
] call CBA_fnc_addSetting;


[
    "KISKA_CBA_supp_flyInHeights",
    "EDITBOX",
    ["Default Fly-In-Heights","When calling for a support with an unspecified set of fly-In-Heights to choose, these will be selectable (meters)"],
    ["KISKA Support Settings","Support Parameters"],
    ["[25,50,100,250,500]"],
    0,
    {
        params ["_value"];

        if (_value isEqualTo "") exitWith {
            missionNamespace setVariable ["KISKA_CBA_supp_flyInHeights","[25,50,100,250,500]"];
        };

        missionNamespace setVariable ["KISKA_CBA_supp_flyInHeights_arr",parseSimpleArray _value];
    }
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_lookingAtMarker_color",
    "COLOR",
    "3D Marker Color",
    ["KISKA Support Settings","Helpers"],
    [1,1,0,1]
] call CBA_fnc_addSetting;
