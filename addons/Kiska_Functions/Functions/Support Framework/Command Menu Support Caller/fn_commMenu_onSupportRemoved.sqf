/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_onSupportRemoved

Description:
    Called when a comm menu support is removed be it through a manual process
    or when a player uses all of a given support.
    
Parameters:
    0: _supportId <STRING> - The support's id
    1: _supportConfig <CONFIG> - The support's config

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_supports_1",
            missionConfigFile >> "CfgCommunicationMenu" >> "MySupport",
            1
        ] call KISKA_fnc_commMenu_onSupportRemoved;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_onSupportRemoved";

params ["_supportId"];

private _idToDetailsMap = localNamespace getVariable "KISKA_commMenu_supportIdToDetailsMap";
_idToDetailsMap deleteAt _supportId;

call KISKA_fnc_commMenu_refresh;


nil
