if !(["cba_common"] call KISKA_fnc_isPatchLoaded) exitWith {};


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
    "KISKA_CBA_VDL_available",
    "CHECKBOX",
    ["View Distance Limiter Available","Can players open the VDL dialog?"],
    ["KISKA GUI Settings","View Distance Limiter"],
    true,
    2
] call CBA_fnc_addSetting;

[
    "KISKA_CBA_VDL_closeMap",
    "CHECKBOX",
    ["View Distance Limiter Closes Map","When opening the View Distance Limiter dialog from the map, should it close the map?"],
    ["KISKA GUI Settings","View Distance Limiter"],
    true,
    0
] call CBA_fnc_addSetting;
