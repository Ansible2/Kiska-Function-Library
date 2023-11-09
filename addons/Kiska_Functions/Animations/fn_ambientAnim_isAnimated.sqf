/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim

Description:
    Returns whether or not a unit is currently using Kiska's ambient animation
     system.

Parameters:
    0: _unit <OBJECT> - A unit to check if they are using KISKA ambient anim system

Returns:
    <BOOL> - Whether or not the unit is using KISKA's ambient animation system

Examples:
    (begin example)
        private _isAnimated = [someUnit] call KISKA_fnc_ambientAnim_isAnimated;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_isAnimated";

params [
    ["_unit",objNull,[objNull]]
];

if !(alive _unit) exitWith {
    false
};

private _isAnimated = !(isNil {_unit getVariable "KISKA_ambientAnimMap"});


_isAnimated
