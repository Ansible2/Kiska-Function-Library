/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setTransmitting

Description:
    Adjusts whether or not the spectrum device is in transmit mode.

    This shows as a green tint to the player's selection area with the full spectrum
     device ui open, and as a wifi esque signal when merely holding the spectrum device.

Parameters:
    0: _isTransmitting : <BOOL> - `true` to set the spectrum device as being in transmit mode

Returns:
    NOTHING

Examples:
    (begin example)
        [true] call KISKA_fnc_spectrum_setTransmitting;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setTransmitting";

params [
    ["_isTransmitting",true,[true]]
];

if !(call KISKA_fnc_spectrum_isInitialized) then {
    localNamespace setVariable ["KISKA_fnc_spectrum_setTransmitting",_isTransmitting];
};

missionNamespace setVariable ["#EM_Transmit",_isTransmitting];
