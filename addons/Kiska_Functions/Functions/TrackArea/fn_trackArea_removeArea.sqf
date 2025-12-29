/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_removeArea

Description:
    Removes an area to track whether or not one of the tracked objects is inside of.

    Provided area to remove will be searched for removal using the `find` command.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.
    1: _area <OBJECT, LOCATION, STRING, ARRAY, NUMBER[][]> - The area to remove 
        from the tracked list.

Returns:
    NOTHING

Examples:
    (begin example)
        [_trackAreaId, MyTrigger] call KISKA_fnc_trackArea_removeArea;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_removeArea";

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
_areas deleteAt (_areas find _area);


nil
