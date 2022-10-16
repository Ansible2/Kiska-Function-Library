/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_openDialog

Description:
    Remotely sets a leader of a group from the server. (Must be run on the server)

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
    	call KISKA_fnc_GCH_openDialog;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_openDialog";

if (missionNamespace getVariable ["KISKA_CBA_GCH_enabled",true]) then {
    createDialog "KISKA_GCH_dialog";
} else {
    ["The Group Changer Dialog is diabled in the Server Addon Options"] call KISKA_fnc_errorNotification;
};


nil
