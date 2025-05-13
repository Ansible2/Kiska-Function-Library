/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_onCalledCloseAirSupport

Description:
    The standard translator to handle a close air support configured support's
     `onSupportCalled` event that is triggered by `KISKA_fnc_supports_call`.
     This standard handler then translates that to and actual call of
     `KISKA_fnc_closeAirSupport`.

Parameters:
    0: _onCallArgs <[HASHMAP,ARRAY]> - An array of the aircraft params map
        and the fire orders to give to the aircraft. See `KISKA_fnc_closeAirSupport`
        for more details.

Returns:
    <BOOL>

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_onCalledCloseAirSupport";

params [
    ["_onCallArgs",[],[[]],2]
];

_onCallArgs call KISKA_fnc_closeAirSupport;


true
