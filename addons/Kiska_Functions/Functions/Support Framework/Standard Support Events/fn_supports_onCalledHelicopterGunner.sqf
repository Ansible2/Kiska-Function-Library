/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_onCalledHelicopterGunner

Description:
    The standard translator to handle a helicopter gunner configured support's
     `onSupportCalled` event that is triggered by `KISKA_fnc_supports_call`.
     This standard handler then translates that to and actual call of
     `KISKA_fnc_helicopterGunner`.

Parameters:
    0: _onCallArgs <ARRAY> - An array of parameters to pass to `KISKA_fnc_helicopterGunner`

Returns:
    <BOOL>

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_onCalledHelicopterGunner";

params [
    ["_onCallArgs",[],[[]]]
];

_onCallArgs call KISKA_fnc_helicopterGunner;


true