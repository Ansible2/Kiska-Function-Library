/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_getTopicName

Description:
    Gets the configured topic name of a given speech topic config.

Parameters:
    0: _config <CONFIG or STRING> - A config path to the topic config or if a string
        the class name of a topic config located in the default root KISKA config.

Returns:
    <STRING> - The configured topic name.

Examples:
    (begin example)
        private _name = ["MyTopicClassInDefaultRoot"] call KISKA_fnc_speech_getTopicName;
    (end)

    (begin example)
        private _name = [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig"
        ] call KISKA_fnc_speech_getTopicName;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_getTopicName";

params [
    ["_config",configNull,[configNull,""]]
];

if (_config isEqualType "") then {
    private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    _config = _defaultConfig >> _config;
};

if (isNull _config) exitWith {
    ["null config passed",true] call KISKA_fnc_log;
    nil
};

private _nameConfig = _config >> "topicName";
if (isNull _nameConfig) exitWith { configName _config };

getText _nameConfig
