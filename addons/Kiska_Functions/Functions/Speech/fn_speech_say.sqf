/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_say

Description:
    Speaks the given line of dialogue for all to hear.

Parameters:
    0: _topicConfig <CONFIG or STRING> - A config path to the topic config or if a string
        the class name of a topic config located in the default root KISKA config.
    1: _lines <STRING or STRING[]> - The class name(s) of the line(s) in the 
        `_topicConfig >> "lines" >> "Sentences"` class to speak.
    2: _speaker <OBJECT> - The unit to speak the line. Does not necessarily need be a man unit.
    3: _listener <OBJECT> - The unit that the line is meant to be spoken to.
        Does not necessarily need be a man unit.
    4: _optionsMap <HASHMAP> - Default: `nil` - An optional hashmap of options 
        that will overwrite any configured options.
        
        - `radioChannel`: <STRING, NUMBER, or BOOL> - Either a radio channel name or a custom radio
            channel number. `true` or `false` can be used to simply force a radio effect to the 
            listener or have no affect respectively. (see `kbTell` for more details)
        - `maxRange`: <number> - The maximum allowable distance between the `_speaker` 
            and `_listener`. Should the distance be exceeded, the line does not play.
        - `subtitle`: <STRING> - Text to display that is what the speaker said.
        - `speakerName`: <STRING> - The name of the speaker. If no name is provided here or
            in the config the `name _speaker` is used instead.
        - `onLineSaid`: <CODE> - An eventhandler that will activate after the line is spoken

            Parameters:
                - 0: <CONFIG> - The config path of the topic.
                - 1: <CONFIG> - The config path of the line.
    
    5: _onAllLinesSaid <CODE, STRING, ARRAY> - Default: `{}` - Code to execute once all 
        the lines have been said. (see `KISKA_fnc_callBack` for examples).
        
        Parameters:
            - 0: <CONFIG> - The config path of the topic.
            - 1: <OBJECT> - The speaker.

Returns:
    <STRING> - the topic name

Examples:
    (begin example)
        [
            "MyTopicClassInDefaultRoot",
            "MyLine",
            player,
            BIS_HQ
        ] call KISKA_fnc_speech_say;
    (end)

    (begin example)
        [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig",
            "MyLine",
            player,
            BIS_HQ,
            createHashMapFromArray [
                ["radioChannel",true]
            ]
        ] call KISKA_fnc_speech_say;
    (end)

    (begin example)
        [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig",
            ["MyLine","MyOtherLine"],
            player,
            BIS_HQ,
            createHashMapFromArray [
                ["radioChannel",true] // applies to all lines
            ]
        ] call KISKA_fnc_speech_say;
    (end)


Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_say";

#define SUBTITLE_PROPERTY_KEY "subtitle"
#define RADIO_CHANNEL_PROPERTY_KEY "radioChannel"
#define MAX_RANGE_PROPERTY_KEY "maxRange"
#define SPEAKER_NAME_PROPERTY_KEY "speakerName"
#define ON_LINE_SAID_PROPERTY_KEY "onLineSaid"
#define CHECK_LINE_SPOKEN_INTERVAL 0.1

params [
    ["_topicConfig",configNull,[configNull,""]],
    ["_lines","",["",[]]],
    ["_speaker",objNull,[objNull]],
    ["_listener",objNull,[objNull]],
    ["_optionsMap",nil],
    ["_onAllLinesSaid",{},[{},"",[]]]
];


if (_topicConfig isEqualType "") then {
    private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    _topicConfig = _defaultConfig >> _topicConfig;
};

if (isNull _topicConfig) exitWith {
    ["null topic config passed",true] call KISKA_fnc_log;
    ""
};

if (isNull _speaker) exitWith {
    ["null speaker passed",true] call KISKA_fnc_log;
    ""
};
if (isNull _listener) exitWith {
    ["null listener passed",true] call KISKA_fnc_log;
    ""
};

if (_lines isEqualType "") then {
    _lines = [_lines];
};
private _lineDetails = [];
_lines apply {
    private _lineName = _x;
    private _lineConfig = _topicConfig >> "lines" >> "Sentences" >> _lineName;
    if (isNull _lineConfig) then {
        [
            [
                "null line config does not exist for ",
                _lineName," in ",_topicConfig
            ],
            true
        ] call KISKA_fnc_log;
        continue;
    };

    /* ----------------------------------------------------------------------------
        Parse Optional Params
    ---------------------------------------------------------------------------- */
    private "_lineOptionsMap";
    if (isNil "_optionsMap") then { 
        _lineOptionsMap = createHashMap; 
    } else {
        _lineOptionsMap = _optionsMap;
    };
    private _optionalMapParams = [
        _lineOptionsMap,
        [
            [
                MAX_RANGE_PROPERTY_KEY, 
                {
                    import "_lineConfig";
                    private _maxRangeConfig = _lineConfig >> MAX_RANGE_PROPERTY_KEY;
                    if (isNull _maxRangeConfig) exitWith { -1 };
                    getNumber _maxRangeConfig
                },
                [123]
            ],
            [
                RADIO_CHANNEL_PROPERTY_KEY,
                {
                    import "_lineConfig";
                    private _radioConfig = _lineConfig >> RADIO_CHANNEL_PROPERTY_KEY;
                    if (isNull _radioConfig) exitWith { false };

                    private _configValue = [_radioConfig,false,"false"] call KISKA_fnc_getConfigData;
                    if (_configValue isEqualType 123) exitWith { _configValue };
                    if (_configValue == "false") exitWith { false };
                    if (_configValue == "true") exitWith { true };

                    _configValue;
                },
                [true,123,""]
            ],
            [
                SUBTITLE_PROPERTY_KEY,
                {
                    import "_lineConfig";
                    getText(_lineConfig >> SUBTITLE_PROPERTY_KEY)
                },
                [""]
            ],
            [
                SPEAKER_NAME_PROPERTY_KEY,
                {
                    import "_lineConfig";
                    private _name = getText(_lineConfig >> SPEAKER_NAME_PROPERTY_KEY);
                    if (_name isNotEqualTo "") exitWith { _name };

                    import "_speaker";
                    name _speaker;
                },
                [""]
            ],
            [
                ON_LINE_SAID_PROPERTY_KEY,
                {
                    import "_lineConfig";
                    private _onLineSaidConfig = _lineConfig >> ON_LINE_SAID_PROPERTY_KEY;
                    compileFinal (getText _onLineSaidConfig)
                },
                [{}]
            ]
        ]
    ] call KISKA_fnc_hashMapParams;
    if (_optionalMapParams isEqualType "") then {
        [_optionalMapParams,true] call KISKA_fnc_log;
        continue;
    };

    (_optionalMapParams select 0) params (_optionalMapParams select 1);
    if (_speakerName isEqualTo "") then {
        _speakerName = name _speaker;
    };
    _lineDetails pushBack [
        _lineConfig,
        _lineName,
        _speakerName,
        _maxRange,
        _radioChannel,
        _subtitle,
        _onLineSaid
    ];
};


private _topicName = [_topicConfig] call KISKA_fnc_speech_getTopicName;
private _addTopicTo = [];
if !(_speaker kbHasTopic _topicName) then { _addTopicTo pushBack _speaker; };
if !(_listener kbHasTopic _topicName) then { _addTopicTo pushBack _listener; };
if (_addTopicTo isNotEqualTo []) then {
    [_topicConfig, _addTopicTo] call KISKA_fnc_speech_addTopic;
};

[_topicConfig,_speaker,_listener,_topicName,_onAllLinesSaid,_lineDetails] spawn {
    params ["_topicConfig","_speaker","_listener","_topicName","_onAllLinesSaid","_lineDetails"];

    _lineDetails apply {
        _x params [
            "_lineConfig",
            "_lineName",
            "_speakerName",
            "_maxRange",
            "_radioChannel",
            "_subtitle",
            "_onLineSaid"
        ];

        if ((_maxRange isNotEqualTo -1) AND ((_speaker distance _listener) > _maxRange)) then {
            [["_maxRange exceeded of -> ",_maxRange," has been exceeded"],false] call KISKA_fnc_log;
            continue;
        };

        /* ----------------------------------------------------------------------------
            Speak Line
        ---------------------------------------------------------------------------- */
        if (_subtitle isNotEqualTo "") then {
            [_subtitle,_speakerName] call KISKA_fnc_speech_showSubtitles;
        };

        _speaker kbTell [_listener, _topicName, _lineName, _radioChannel];
        
        private _wasSaid = false;
        private _isAlive = true;
        waitUntil { 
            sleep CHECK_LINE_SPOKEN_INTERVAL; 
            _isAlive = alive _speaker;
            _wasSaid = _speaker kbWasSaid [_listener, _topicName, _lineName, 1];

            !_isAlive OR _wasSaid
        };

        if (_wasSaid AND {_onLineSaid isNotEqualTo {}}) then {
            [[_topicConfig,_lineConfig],_onLineSaid] call KISKA_fnc_callBack;
        };

        if !(_isAlive) then { break };
    };

    if (_onAllLinesSaid isEqualTo {}) exitWith {};
    [[_topicConfig,_speaker],_onAllLinesSaid] call KISKA_fnc_callBack;
};


_topicName
