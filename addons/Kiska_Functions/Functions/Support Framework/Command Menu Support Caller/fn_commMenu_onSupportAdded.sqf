/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_onSupportAdded

Description:
    Designed to be an event handler for when a support that's meant to be used in
     the communication menu is added.
    
Parameters:
    0: _supportId <STRING> - The support's id
    1: _supportConfig <CONFIG> - The support config
    2: _numberOfUsesLeft <NUMBER> - The number of support uses left or rounds
        available to use. If less than 0, the configed value will be used.

Returns:
    NOTHING

Examples:
    (begin example)
        private _commMenuSupportId = [
            "KISKA_supports_1",
            missionConfigFile >> "CfgCommunicationMenu" >> "MySupport",
            1
        ] call KISKA_fnc_commMenu_onSupportAdded;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_onSupportAdded";

#define SUPPORT_CURSOR "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"

params [
    "",
    ["_supportConfig",configNull,[configNull]]
];

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";
if (isNull _commMenuDetailsConfig) exitWith {
    ["_supportConfig has no KISKA_commMenuDetails class defined",true] call KISKA_fnc_log;
    nil
};

call KISKA_fnc_commMenu_refresh;
