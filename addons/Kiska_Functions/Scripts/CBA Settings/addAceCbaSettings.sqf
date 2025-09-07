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
    "KISKA_CBA_ACE_unconciousPlayerIsCaptive",
    "CHECKBOX",
    ["Unconscious Players Are Captive","When turned on, players that are unconscious will be put in a captive state which will stop AI from engaging their bodies. They will be set to not be captive after wake up. (TURN OFF IF MANAGING CAPTIVE STATUS WITH ACE)"],
    ["KISKA ACE Settings","Medical"],
    true,
    0
] call CBA_fnc_addSetting;
