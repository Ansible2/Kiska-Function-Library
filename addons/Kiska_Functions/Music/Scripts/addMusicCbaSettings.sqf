#include "..\Headers\Music Common Defines.hpp"
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
    "KISKA_CBA_showSongNames",
    "CHECKBOX",
    ["Print Song Names On Screen","When music is played through KISKA's music system, a tiled text will appear with the song's name on screen"],
    ["KISKA Misc Settings","Music"],
    true,
    0
] call CBA_fnc_addSetting;

private _randomMusicTimeToolTip = "There are three formats for track spacing:";
_randomMusicTimeToolTip = _randomMusicTimeToolTip + "\n1. '2' - All random music tracks will be spaced two seconds apart.";
_randomMusicTimeToolTip = _randomMusicTimeToolTip + "\n2. '[2]' - All random music tracks will be spaced UP TO two seconds apart.";
_randomMusicTimeToolTip = _randomMusicTimeToolTip + "\n3. '[1,2,3]' - All random music tracks will be spaced between 1 minimum and 3 maximum but gravitating towards 2.";
[
    "KISKA_CBA_randomMusicTime",
    "EDITBOX",
    ["Random Music Track Spacing",_randomMusicTimeToolTip],
    ["KISKA Misc Settings","Music"],
    str (GET_MUSIC_RANDOM_TIME_BETWEEN),
    1,
    {
        params ["_value"];
        _value = [_value] call BIS_fnc_parseNumberSafe;

        if !([_value] call KISKA_fnc_setRandomMusicTime) then {
            KISKA_CBA_randomMusicTime = GET_MUSIC_RANDOM_TIME_BETWEEN;
        };
    }
] call CBA_fnc_addSetting;
