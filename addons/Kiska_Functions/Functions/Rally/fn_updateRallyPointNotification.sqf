/* ----------------------------------------------------------------------------
Function: KISKA_fnc_updateRallyPointNotification

Description:
    Informs the player that their rally point was updated

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        remoteExec ["KISKA_fnc_updateRallyPointNotification",somePlayer];
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_updateRallyPointNotification";

#define HEADER_COLOR [0,0.3,0.6,1]

if (!hasInterface) exitWith {};

[["MESSAGE",1.1,HEADER_COLOR],"Rally Point Was Updated",3,false] call KISKA_fnc_notify;


nil
