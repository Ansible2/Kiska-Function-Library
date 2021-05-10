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
    "KISKA_CBA_log",
    "CHECKBOX",
    ["Allow KISKA Logs","Turns on or off logging called through KISKA_fnc_log"],
    ["KISKA Misc Settings","Logging"],
    true,
    0
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_logWithError",
    "CHECKBOX",
    ["Log With Error Message","Prints Kiska logs on screen with BIS_fnc_error (when the function setting is set to default param)"],
    ["KISKA Misc Settings","Logging"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_logScripts_str",
    "EDITBOX",
    ["Loggable Scripts","If a script's name is not within the array, it will be ignored by KISKA_fnc_log. 'all' in the array will print everything. Names MUST be lowercase AND enclosed with ''"],
    ["KISKA Misc Settings","Logging"],
    ["['all']"],
    0,
    {
        params ["_value"];

        if (_value isEqualTo "") exitWith {
            missionNamespace setVariable ["KISKA_CBA_logScripts_str","['all']"];
        };

        missionNamespace setVariable ["KISKA_CBA_logScripts_array",parseSimpleArray _value];
    }
] call CBA_fnc_addSetting;
