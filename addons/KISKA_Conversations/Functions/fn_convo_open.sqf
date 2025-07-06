/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convo_open

Description:
    Initializes a converstaion sequence. This is the entry point to start a conversation
     between the local player and a given NPC that is a configured KISKA conversation.
     A KISKA conversation is an RPG like communication system.

Parameters:
    0: _topicConfig <CONFIG or STRING> - A config path to the *conversation* topic 
        config or if a string the class name of a topic config located in the 
        default root KISKA config (see `KISKA_fnc_speech_getDefaultConfigRoot`).
    1: _conversationName <STRING> - the class name of the line in the 
        `_topicConfig >> "conversations"` class to open a dialog for.
    2: _speakingTo <OBJECT> - The NPC "person" the player is supposed to be speaking to.
        Can also be something like a game logic.
    3. _playPreamble <BOOL> - Default: `false` - Whether or not the configured `preambleLine`s 
        should be spoken by the `_speakingTo` entity.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "MyTopicConfigClass",
            "MyConversationConfigClass",
            BIS_HQ
        ] call KISKA_fnc_convo_open;
    (end)

    (begin example)
        [
            missionConfigFile >> "MySpeechConfig" >> "MyTopicConfigClass",
            "MyConversationConfigClass",
            Miller,
            false
        ] call KISKA_fnc_convo_open;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convo_open";

if !(hasInterface) exitWith {};

params [
    ["_topicConfig",configNull,[configNull,""]],
    ["_conversationName","",[""]],
    ["_speakingTo",objNull,[objNull]],
    ["_playPreamble",true,[false]]
];


if (_topicConfig isEqualType "") then {
    private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    _topicConfig = _defaultConfig >> _topicConfig;
};

if (isNull _topicConfig) exitWith {
    ["null topic config passed",true] call KISKA_fnc_log;
    call KISKA_fnc_convo_close;
    nil
};

private _conversationConfig = _topicConfig >> "conversations" >> _conversationName;
if (isNull _conversationConfig) exitWith {
    [
        [
            "Conversation config does not exist for ",
            _conversationName,
            " in ",
            _topicConfig
        ],
        true
    ] call KISKA_fnc_log;
    call KISKA_fnc_convo_close;
    nil
};

if (isNull _speakingTo) exitWith {
    ["null object to speak to passed",true] call KISKA_fnc_log;
    call KISKA_fnc_convo_close;
    nil
};

/* ----------------------------------------------------------------------------
    Handle Player
---------------------------------------------------------------------------- */
if (isNil {localNamespace getVariable "KISKA_convo_playerKilledEventId"}) then {
    private _eventId = player addEventHandler ["KILLED", {
        call KISKA_fnc_convo_close;
        localNamespace setVariable ["KISKA_convo_playerKilledEventId",nil];
        player removeEventHandler [_thisEvent,_thisEventHandler];
    }];

    localNamespace setVariable ["KISKA_convo_playerKilledEventId",_eventId];
};

/* ----------------------------------------------------------------------------
    Handle Speaker
---------------------------------------------------------------------------- */
localNamespace setVariable ["KISKA_convo_speakingTo",_speakingTo];
if (isNil {_speakingTo getVariable "KISKA_convo_killedEventId"}) then {
    private _eventId = _speakingTo addEventHandler ["KILLED", {
        params ["_unit"];

        private _speakingTo = localNamespace getVariable ["KISKA_convo_speakingTo",objNull];
        if (_speakingTo isEqualTo _unit) then {
            call KISKA_fnc_convo_close;
        };
    }];

    _speakingTo setVariable ["KISKA_convo_killedEventId",_eventId];
};

/* ----------------------------------------------------------------------------
    Handle Preamble
---------------------------------------------------------------------------- */
private "_preambleLines";
if (
    !(_playPreamble) OR
    {
        _preambleLines = [_conversationConfig >> "preambleLine"] call KISKA_fnc_getConfigData;
        (isNil "_preambleLines") OR
        {_preambleLines isEqualTo ""} OR 
        {_preambleLines isEqualTo []}
    }
) exitWith {
    [
        _speakingTo,
        _conversationConfig,
        _topicConfig
    ] call KISKA_fnc_convo_createResponseDialog;

    nil
};

[
    _topicConfig,
    _preambleLines,
    _speakingTo,
    player,
    nil,
    [[_speakingTo,_conversationConfig,_topicConfig], {
        _thisArgs call KISKA_fnc_convo_createResponseDialog;
    }]
] call KISKA_fnc_speech_say;


nil
