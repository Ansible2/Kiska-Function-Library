/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convo_hasOptionBeenSelected

Description:
    Determines whether or not the local player has selected a given dialogue option.

Parameters:
    0: _selectedOptionConfig <CONFIG> - The config of the selected option
        (`TOPIC_CONFIG >> "conversations" >> "MyConvo" >> "Options" >> "MyOption"`) 
        config to check.

Returns:
    NOTHING

Examples:
    (begin example)
        private _optionConfig = 
            missionConfigFile >> 
            "KISKA_speech" >> 
            "MyTopic" >> 
            "conversations" >> 
            "MyOptions" >> 
            "Option_1";
        private _wasSelected = _optionConfig call KISKA_fnc_convo_hasOptionBeenSelected;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convo_hasOptionBeenSelected";

params [
    ["_optionConfig",configNull,[configNull]]
];

if (isNull _optionConfig) exitWith {};

private _selectedOptionsSet = localNamespace getVariable "KISKA_convo_selectedOptionsSet";
if (isNil "_selectedOptionsSet") then {
    _selectedOptionsSet = createHashMap;
    localNamespace setVariable ["KISKA_convo_selectedOptionsSet",_selectedOptionsSet];
};


_optionConfig in _selectedOptionsSet
