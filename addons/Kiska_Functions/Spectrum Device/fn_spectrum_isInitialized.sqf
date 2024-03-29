/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_isInitialized

Description:
    Determines whether the spectrum device display has been initialized.

    This display will be created once a player has added the device to their
     inventory. They do not have to equip the device.

Parameters:
    NONE

Returns:
    <BOOL> - `true` if the spectrum device has been initialized, `false` if not

Examples:
    (begin example)
        private _isInitialized = call KISKA_fnc_spectrum_isInitialized
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_isInitialized";

!(isNil { uiNamespace getVariable "rscweaponspectrumanalyzergeneric" })