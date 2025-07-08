/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_getTopicEventHandler

Description:
    Gets the configured eventhandler code of a given speech topic config.

Parameters:
    0: _config <CONFIG or STRING> - A config path to the topic config or if a string
        the class name of a topic config located in the default root KISKA config.

Returns:
    <CODE> - The compiled eventhandler code.

Examples:
    (begin example)
        private _eventHandler = ["MyTopicClassInDefaultRoot"] call KISKA_fnc_speech_getTopicEventHandler;
    (end)

    (begin example)
        private _eventHandler = [
            configFile >> "MySpeechConfigs" >> "MyTopicConfig"
        ] call KISKA_fnc_speech_getTopicEventHandler;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_getTopicEventHandler";

params [
    ["_config",configNull,[configNull,""]]
];

if (_config isEqualType "") then {
    private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    _config = _defaultConfig >> _config;
};

if (isNull _config) exitWith {
    ["null config passed",true] call KISKA_fnc_log;
    {}
};


private _eventHandlerMap = localNamespace getVariable "KISKA_speech_topicEventHandlerMap";
if (isNil "_eventHandlerMap") then {
	_eventHandlerMap = createHashMap;
	localNamespace setVariable ["KISKA_speech_topicEventHandlerMap",_eventHandlerMap];
};


if (_config in _eventHandlerMap) exitWith { _eventHandlerMap get _config };

private _uncompiledCode = getText(_config >> "eventHandler");
private _compiled = compileFinal _uncompiledCode;
_eventHandlerMap set [_config,_compiled];


_compiled
