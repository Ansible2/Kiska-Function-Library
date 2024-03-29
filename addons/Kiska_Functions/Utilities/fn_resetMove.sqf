/* ----------------------------------------------------------------------------
Function: KISKA_fnc_selectRandom

Description:
    Call switchMove "" on a given unit. This function was created because as of release 
     2.10 there is an issue where remoteExec'ing switchMove "" on a unit directly within 
     some functions (KISKA_fnc_ambientAnim_stop) does not work as intended 
     (the intention being the unit returns to normal animations)
    
    Remoteexecuting this function, however, fixes the issue.

Parameters:
    0: _unit <OBJECT> - The unit to reset animation on

Returns:
    NOTHING

Examples:
    (begin example)
        [_unit] remoteExecCall ["KISKA_fnc_resetMove"]
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_resetMove";

params [
    ["_unit",objNull,[objNull]]
];

_unit switchMove "";