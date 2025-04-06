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
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]],
    ["_numberOfUsesLeft",1,[123]]
];

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";
if (isNull _commMenuDetailsConfig) exitWith {
    ["_supportConfig has no KISKA_commMenuDetails class defined",true] call KISKA_fnc_log;
    nil
};

private _text = getText(_commMenuDetailsConfig >> "text");
private _onSupportSelected = getText(_commMenuDetailsConfig >> "onSupportSelected");
private _icon = getText(_commMenuDetailsConfig >> "icon");
private _iconText = getText(_commMenuDetailsConfig >> "iconText");
private _cursor = getText(_commMenuDetailsConfig >> "cursor");

// TODO: add the rest of the logic
// This essentially needs to replace the logic of BIS_fnc_addCommMenuItem
