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
    "KISKA_CBA_supportManager_usedIconColor",
    "COLOR",
    ["Color of Used Support Icons","When a support was already used, it's icon will show this color"],
    ["KISKA Support Manager Settings","Colors"],
    [0.75,0,0,1],
    0
] call CBA_fnc_addSetting;


[
    "KISKA_CBA_supportManager_maxSupports",
    "LIST",
    ["Max Number Of Menu Items","The total number of supports that can be stored in a single player's communication support menu"],
    ["KISKA Support Manager Settings","Misc"],
    [
        [1,2,3,4,5,6,7,8,9,10],
        [1,2,3,4,5,6,7,8,9,10],
        9
    ],
    1
] call CBA_fnc_addSetting;