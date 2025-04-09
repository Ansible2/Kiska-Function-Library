/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_onSupportAdded

Description:
    Designed to be an event handler for when a support that's meant to be used in
     the communication menu is added.
    
Parameters:
    0: _supportId <STRING> - The support's id
    1: _supportConfig <CONFIG> - The support config
    2: _numberOfUsesLeft <NUMBER> - The number of support uses left or rounds
        available to use.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_supports_1",
            missionConfigFile >> "CfgCommunicationMenu" >> "MySupport",
            1
        ] call KISKA_fnc_commMenu_onSupportAdded;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_onSupportAdded";

params [
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]]
];

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";
if (isNull _commMenuDetailsConfig) exitWith {
    ["_supportConfig has no KISKA_commMenuDetails class defined",true] call KISKA_fnc_log;
    nil
};

private _commMenuMap = call KISKA_fnc_commMenu_getMap;
_commMenuMap set [_supportId,_supportConfig];

call KISKA_fnc_commMenu_refresh


nil
