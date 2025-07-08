/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_showSubtitles

Description:
    Shows subtitles for a given line of text.

Parameters:
    0: _subtitle <STRING> - The text of what's being said.
    1: _speakerName <STRING> - Default: `"unknown"` - The name of the speaker.

Returns:
    NOTHING

Examples:
    (begin example)
        ["Hello World","someone"] call KISKA_fnc_speech_showSubtitles;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_showSubtitles";

params [
    ["_subtitle","",[""]],
    ["_speakerName","unknown",[""]]
];


[_speakerName,_subtitle] spawn BIS_fnc_showSubtitle;

nil