/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_isTransmitting

Description:
    Checks whether or not the local machine is transimitting on the spectrum device.

    This shows as a green tint to the player's selection area with the full spectrum
     device ui open, and as a wifi esque signal when merely holding the spectrum device.

Parameters:
    NONE

Returns:
    <BOOL> - `true` if transmitting, `false` if not

Examples:
    (begin example)
        private _isTransmitting = call KISKA_fnc_spectrum_isTransmitting
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_isTransmitting";

missionNamespace getVariable ["#EM_Transmit",false];
