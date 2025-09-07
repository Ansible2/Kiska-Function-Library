/* ----------------------------------------------------------------------------
Function: KISKA_fnc_datalinkMsg

Description:
    Displays a message to the player and creates a diary entry of that message.
    Also can play a sound when the notification pops up.

Parameters:
    0: _message : <STRING or ARRAY> - If string, the message to display as title.
        
        If array:
        - 0: _text : <STRING> - Text to display or path to .paa or .jpg
            image (may be passed directly if only text is required)
        - 1: _size : <NUMBER> - Scale of text
        - 2: _color : <ARRAY> - RGB or RGBA color (range 0-1). (optional, default: [1, 1, 1, 1])

    1: _canSkip : <BOOL> - Can the notification be skipped when another is in the queue
    2: _lifetime : <NUMBER> - How long the notification will be visible (min of 2 seconds)
    3: _sound : <STRING> - A sound

Returns:
    NOTHING

Examples:
    (begin example)
        ["this is the message", 5] call KISKA_fnc_datalinkMsg;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_datalinkMsg";

#define RED_RGBA [0.75,0,0,1]

if !(hasInterface) exitWith {};

// if function is not run in the same environment, causes an issue where there will be two
/// at least "Datalink Messages" sub-subjects
if (canSuspend) exitWith {
    [
        KISKA_fnc_datalinkMsg,
        _this
    ] call CBA_fnc_directCall;
};

params [
    ["_message","",["",[]]],
    ["_canSkip",false,[true]],
    ["_lifetime",4,[123]],
    ["_sound","",[""]]
];


[
    {
        params [
            "_message",
            "_sound"
        ];

        if (_sound isNotEqualTo "") then {
            playSound _sound;
        };

        [
            ["DATALINK",1.1,RED_RGBA],
            _message,
            _lifetime,
            _canSkip
        ] call KISKA_fnc_notify;

        [["Datalink Messages","- " + _message]] call KISKA_fnc_addKiskaDiaryEntry;
    },
    [_message,_playSound],
    _waitTime
] call KISKA_fnc_CBA_waitAndExecute;
