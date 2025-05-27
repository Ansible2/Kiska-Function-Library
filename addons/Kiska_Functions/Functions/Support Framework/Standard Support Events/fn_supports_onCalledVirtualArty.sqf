/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_onCalledVirtualArty

Description:
    The standard translator to handle a virtual artillery configured support's
     `onSupportCalled` event that is triggered by `KISKA_fnc_supports_call`.
     This standard handler then translates that to and actual call of
     `KISKA_fnc_virtualArty`.

Parameters:
    0: _onCallArgs <[STRING,NUMBER]> - An array in the shape of `[ammo class, radius of fire]`.
    1: _supportId <STRING> - The ID of the specific support.
    2: _supportConfig <CONFIG> - The support's config path.
    3: _targetPosition <PositionASL[]> - The position to target.
    4: _numberOfRoundsToFire <NUMBER> - How many rounds to fire

Returns:
    <BOOL>

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_onCalledVirtualArty";

params [
    ["_onCallArgs",[],[[]],2],
    "",
    "",
    ["_targetPosition",[],[[]],3],
    ["_numberOfRoundsToFire",0,[123]]
];

_onCallArgs params [
    ["_ammoType","",[""]],
    ["_radiusOfFire",25,[123]]
];

[
    _targetPosition,
    _ammoType,
    _radiusOfFire,
    _numberOfRoundsToFire
] spawn KISKA_fnc_virtualArty;


true
