/* ----------------------------------------------------------------------------
Function: KISKA_fnc_speech_getDefaultConfigRoot

Description:
    Returns the default config path of where configuration for KISKA speeches can
	 go.

Parameters:
    NONE

Returns:
    <CONFIG> - The default config path

Examples:
    (begin example)
        private _defaultConfig = call KISKA_fnc_speech_getDefaultConfigRoot;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_speech_getDefaultConfigRoot";

missionConfigFile >> "KISKA_speech"
