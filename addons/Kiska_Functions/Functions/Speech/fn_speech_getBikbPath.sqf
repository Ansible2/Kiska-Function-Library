/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_getBikbPath

Description:
    Gets the configured bikb file path of a given speech topic config.

Parameters:
    0: _topicConfig <CONFIG or STRING> - A config path to the topic config or if a string
        the class name of a topic config located in the default root KISKA config.

Returns:
    <STRING> - The configured file path.

Examples:
    (begin example)
        private _path = ["MyTopicClassInDefaultRoot"] call KISKA_fnc_speech_getBikbPath;
    (end)

    (begin example)
        private _path = [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig"
        ] call KISKA_fnc_speech_getBikbPath;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_getBikbPath";

params [
    ["_topicConfig",configNull,[configNull,""]]
];

if (_topicConfig isEqualType "") then {
    private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    _topicConfig = _defaultConfig >> _topicConfig;
};

if (isNull _topicConfig) exitWith {
    ["null config passed",true] call KISKA_fnc_log;
    nil
};


getText(_topicConfig >> "bikb")