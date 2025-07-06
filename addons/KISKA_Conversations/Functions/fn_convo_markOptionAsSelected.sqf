/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convo_markOptionAsSelected

Description:
    Handles the logic of when an option is selected during a conversation.

Parameters:
    0: _selectedOptionConfig <CONFIG> - The config of the selected option
        (`TOPIC_CONFIG >> "conversations" >> "MyConvo" >> "Options" >> "MyOption"`) 
        config to use.

Returns:
    NOTHING

Examples:
    (begin example)
        private _optionConfig = 
            missionConfigFile >> 
            "CfgKiskaSpeech" >> 
            "MyTopic" >> 
            "conversations" >> 
            "MyOptions" >> 
            "Option_1";
        _optionConfig call KISKA_fnc_convo_markOptionAsSelected;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convo_markOptionAsSelected";

params [
    ["_optionConfig",configNull,[configNull]]
];

if (isNull _optionConfig) exitWith {};

private _selectedOptionsSet = localNamespace getVariable "KISKA_convo_selectedOptionsSet";
if (isNil "_selectedOptionsSet") then {
    _selectedOptionsSet = createHashMap;
    localNamespace setVariable ["KISKA_convo_selectedOptionsSet",_selectedOptionsSet];
};

_selectedOptionsSet set [_optionConfig,_optionConfig];

nil
