/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_getFsmPath

Description:
    Gets the configured FSM file path of a given speech topic config.

Parameters:
    0: _config <CONFIG or STRING> - A config path to the topic config or if a string
        the class name of a topic config located in the default root KISKA config.

Returns:
    <STRING> - The configured file path.

Examples:
    (begin example)
        private _path = ["MyTopicClassInDefaultRoot"] call KISKA_fnc_speech_getFsmPath;
    (end)

    (begin example)
        private _path = [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig"
        ] call KISKA_fnc_speech_getFsmPath;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_getFsmPath";

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


getText(_config >> "fsm")
