/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_simplifyAngle

Description:
    Copied version of the CBA function `CBA_fnc_simplifyAngle`.

    Returns an equivalent angle to the specified angle in the range 0 to 360.

    If the input angle is in the range 0 to 360, it will be returned unchanged.

Parameters:
    0: _angle <NUMBER> - The unadjusted angle

Returns:
    <NUMBER> - The angle

Example:
    (begin example)
        [912] call KISKA_fnc_CBA_simplifyAngle;
    (end)

Author(s):
    SilentSpike 2015-27-07,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_simplifyAngle";

params [
    ["_angle",0,[123]]
];

((_angle % 360) + 360) % 360