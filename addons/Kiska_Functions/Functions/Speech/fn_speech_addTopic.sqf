/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_addTopic

Description:
    Adds a configured topic to a given list of units.

Parameters:
    0: _config <CONFIG or STRING> - A config path to the topic config or if a string
        the class name of a topic config located in the default root KISKA config.
    1: _units <OBJECT[]> - The units to add the topic to.

Returns:
    <STRING> - The topic's name.

Examples:
    (begin example)
        ["MyTopicClassInDefaultRoot",[player]] call KISKA_fnc_speech_addTopic;
    (end)

    (begin example)
        [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig",
            [player]
        ] call KISKA_fnc_speech_addTopic;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_addTopic";

params [
    ["_config",configNull,[configNull,""]],
    ["_units",[],[[]]]
];

if (_config isEqualType "") then {
    private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    _config = _defaultConfig >> _config;
};

if (isNull _config) exitWith {
    ["null config passed",true] call KISKA_fnc_log;
    ""
};

if (_units isEqualTo []) exitWith {
    [["No units to add the topic to! ",_config],true] call KISKA_fnc_log;
    ""
};


private _topicName = [_config] call KISKA_fnc_speech_getTopicName;
private _bikbPath = [_config] call KISKA_fnc_speech_getBikbPath;
private _fsmPath = [_config] call KISKA_fnc_speech_getFsmPath;
private _topicEventHandler = [_config] call KISKA_fnc_speech_getTopicEventHandler;
private _topic = [
    _topicName,
    _bikbPath,
    _fsmPath,
    _topicEventHandler
];
_units apply {
    _x kbAddTopic _topic;
};


_topicName
