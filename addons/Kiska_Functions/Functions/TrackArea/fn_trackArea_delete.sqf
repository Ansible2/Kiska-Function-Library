/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_delete

Description:
    Fully removes a tracked area and it's associated reference information from
     track area global variables.
     

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID to delete.

Returns:
    NOTHING

Examples:
    (begin example)
        _trackAreaId call KISKA_fnc_trackArea_delete;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_delete";

params [
    ["_trackAreaId","",[""]]
];

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _trackAreaInfoMap = _containerMap get _trackAreaId;
if (isNil "_trackAreaInfoMap") exitWith {};

_trackAreaId call KISKA_fnc_trackArea_stopTracking;
_containerMap deleteAt _trackAreaId;


nil
