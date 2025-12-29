/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_addObject

Description:
    Adds an object to the given tracker to that will continously check whether
     it is inside the tracker's defined areas. Duplicate entries will be filtered
     from the list of tracked objects.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.
    1: _object <OBJECT> - An object that will be tracked.

Returns:
    NOTHING

Examples:
    (begin example)
        [_trackAreaId, player] call KISKA_fnc_trackArea_addObject;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_addObject";

params [
    ["_trackAreaId","",[""]],
    ["_object",objNull,[objNull]]
];

if !(alive _object) exitWith {
    ["_object is not alive",true] call KISKA_fnc_log;
    nil
};

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _trackAreaInfoMap = _containerMap get _trackAreaId;
if (isNil "_trackAreaInfoMap") exitWith {
    [["_trackAreaId ",_trackAreaId," does not exist"],true] call KISKA_fnc_log;
    nil
};

private _objects = _trackAreaInfoMap getOrDefaultCall ["trackedObjects",{[]},true];
_objects pushBackUnique _object;


nil
