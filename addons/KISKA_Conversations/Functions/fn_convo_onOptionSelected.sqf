/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convo_onOptionSelected

Description:
    Handles the logic of when an option is selected during a conversation.

Parameters:
    0: _selectedOptionConfig <CONFIG> - The config of the selected option
        (`_topicConfig >> "conversations" >> "MyConvo" >> "Options" >> "MyOption"`) 
        config to use.
    1: _speakingTo <OBJECT> - The NPC "person" the player is supposed to be speaking to.
        Can also be something like a game logic.
    2: _topicConfig <CONFIG> - A config path to the *conversation* topic config.

Returns:
    NOTHING

Examples:
    (begin example)
        SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convo_onOptionSelected";
disableSerialization;

params [
    ["_selectedOptionConfig",configNull,[configNull]],
    "_speakingTo",
    "_topicConfig"
];

if (isNull _selectedOptionConfig) exitWith {
    ["null selected option config passed!",true] call KISKA_fnc_log;
    call KISKA_fnc_convo_close;
    nil
};

private _display = localNamespace getVariable ["KISKA_converstationResponse_display",displayNull];
(allControls _display) apply { 
    _x ctrlShow false;
    _x ctrlEnable false;
};

private _selectedOptionConfig = _optionConfigs select _selectedIndex;
private _fn_afterLineSelected = [
    [_topicConfig,_selectedOptionConfig,_speakingTo],
    {
        private _fn_openNextConversation = [_thisArgs, {
            _thisArgs params ["_topicConfig","_selectedOptionConfig","_speakingTo"];
            private _nextConvo = getText(_selectedOptionConfig >> "nextConvo");
            if (_nextConvo isEqualTo "") exitWith { call KISKA_fnc_convo_close };

            [
                _topicConfig,
                _nextConvo,
                _speakingTo,
                [_selectedOptionConfig >> "playNextPreamble",true,true] call KISKA_fnc_getConfigData
            ] call KISKA_fnc_convo_open;
        }];

        _thisArgs params ["_topicConfig","_selectedOptionConfig","_speakingTo"];
        private _postLines = [_selectedOptionConfig >> "postLine"] call KISKA_fnc_getConfigData;
        if (
            !(isNil "_postLines") AND
            {_postLines isNotEqualTo ""} AND
            {_postLines isNotEqualTo []}
        ) exitWith {
            [
                _topicConfig,
                _postLines,
                _speakingTo,
                player,
                nil,
                _fn_openNextConversation
            ] call KISKA_fnc_speech_say;

            nil
        };
        
        [[],_fn_openNextConversation] call KISKA_fnc_callBack;
    }
];

private _lineName = getText (_selectedOptionConfig >> "line");
if (_lineName isEqualTo "") exitWith {
    [[],_fn_afterLineSelected] call KISKA_fnc_callBack;
    nil
};

[
    _topicConfig,
    _lineName,
    player,
    _speakingTo,
    nil,
    _fn_afterLineSelected
] call KISKA_fnc_speech_say;
_selectedOptionConfig call KISKA_fnc_convo_markOptionAsSelected;


nil
