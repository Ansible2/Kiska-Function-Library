/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_removeObject

Description:
    Removes an object to track from the given area tracker.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.
    1: _object <OBJECT> - The object to remove from the tracking list.

Returns:
    NOTHING

Examples:
    (begin example)
        [_trackAreaId, player] call KISKA_fnc_trackArea_removeObject;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_removeObject";

params [
    ["_trackAreaId","",[""]],
    ["_object",nil,[[],objNull,locationNull,""]]
];

if (isNil "_object") exitWith {
    ["_object not provided",true] call KISKA_fnc_log;
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

private _trackedObjects = _trackAreaInfoMap getOrDefaultCall ["trackedObjects",{[]},true];
_trackedObjects deleteAt (_trackedObjects find _object);


nil
