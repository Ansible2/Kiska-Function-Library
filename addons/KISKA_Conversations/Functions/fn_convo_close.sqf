/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convo_close

Description:
    Cleans up the conversation system and closes the response dialog.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_convo_close;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convo_open";
private _display = localNamespace getVariable ["KISKA_converstationResponse_display",displayNull];
_display closeDisplay 2;

localNamespace setVariable ["KISKA_convo_speakingTo",nil];


nil
