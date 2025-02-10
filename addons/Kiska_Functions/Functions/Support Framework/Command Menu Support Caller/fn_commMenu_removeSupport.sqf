/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_removeSupport

Description:
    Removes a support from the communication menu by the given ID.
    
Parameters:
    0: _commMenuId <NUMBER> - The id returned from `KISKA_fnc_commMenu_addSupport`

Returns:
    <[CONFIG,NUMBER]> - The support item, made up of the support's config and the number
        of uses left.

Examples:
    (begin example)
        private _supportInfo = [0] call KISKA_fnc_commMenu_removeSupport;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_removeSupport";

params [
    ["_commMenuId",-1,[123]]
];


[player,_commMenuId] call BIS_fnc_removeCommMenuItem;
private _supportMap = call KISKA_fnc_commMenu_getSupportMap;
_supportMap deleteAt _commMenuId
