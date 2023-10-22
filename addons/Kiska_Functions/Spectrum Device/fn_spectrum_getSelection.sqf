/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_getSelection

Description:
    Provides the current MHz area selected on the local machine. This is where the
     blue bar that the player manipulates with the scroll wheel is positioned.

Parameters:
    NONE

Returns:
    <[NUMBER,NUMBER]> - The min and max of the player's currently selected area

Examples:
    (begin example)
        private _selection = call KISKA_fnc_spectrum_getSelection;
        // _selection params ["_min","_max"];
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_getSelection";

[
    missionNamespace getVariable ["#EM_SelMin", 100],
    missionNamespace getVariable ["#EM_SelMax", 102.5]
]
