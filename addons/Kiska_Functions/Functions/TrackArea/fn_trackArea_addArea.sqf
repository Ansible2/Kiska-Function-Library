/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_addArea

Description:
    Adds an area to track whether or not one of the tracked objects is inside of.

    Areas cannot be duplicated within a single tracker only so far as can be enforced 
     by the use of `pushBackUnique` to the list of areas.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.
    1: _area <OBJECT, LOCATION, STRING, ARRAY, NUMBER[][]> - The area to add to the
        tracked list. This must be compatible with the right-side area arguement of
        `inAreaArray`.

Returns:
    NOTHING

Examples:
    (begin example)
        [_trackAreaId, MyTrigger] call KISKA_fnc_trackArea_addArea;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_addArea";

params [
    ["_trackAreaId","",[""]],
    ["_area",nil,[[],objNull,locationNull,""]]
];

if (isNil "_area") exitWith {
    ["_area not provided",true] call KISKA_fnc_log;
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

private _areas = _trackAreaInfoMap getOrDefaultCall ["areas",{[]},true];
_areas pushBackUnique _area;


nil
