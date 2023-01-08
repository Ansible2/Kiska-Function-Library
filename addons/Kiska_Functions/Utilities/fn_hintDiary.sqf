/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hintDiary

Description:
    Displays a hint to the player and (always) creates a chronological
     diary entry and an entry in the defined subject if desired.

Parameters:
    0: _hintText <STRING> - The actual text shown in the hint
    1: _subject <STRING> - The subject line in the journal for the hint (OPTIONAL)
    2: _silent <BOOL> - true for silent hint

Returns:
    <DIARY-RECORD> - The created diary record.
    
Examples:
    (begin example)
        ["this is the message", "Subject"] call KISKA_fnc_hintDiary;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hintDiary";

if !(hasInterface) exitWith {};

// if function is not run in the same environment, causes an issue where ther will be two
/// at least "Chronological Hint List" sub-subjects
if (canSuspend) exitWith {
    [
        {_this call KISKA_fnc_hintDiary},
        _this
    ] call CBA_fnc_directCall;
};

params [
    ["_hintText","This is shown",[""]],
    ["_subject","",[""]],
    ["_silent",false,[true]]
];

if (_silent) then {
    hintSilent _hintText;
} else {
    hint _hintText;
};

[["Chronological Hint List","- " + _hintText]] call KISKA_fnc_addKiskaDiaryEntry;

private _diaryRecord = diaryRecordNull;
if (_subject isNotEqualTo "") then {
    _diaryRecord = [[_subject,"- " + _hintText]] call KISKA_fnc_addKiskaDiaryEntry;
};


_diaryRecord
