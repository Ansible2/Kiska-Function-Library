scriptName "KISKA_fnc_trackArea_addArea";

params [
    ["_trackAreaId","",[""]],
    ["_area",nil,[[],objNull,locationNull,""]]
];

if (isNil "_area") exitWith {
    ["_area not provided",true] call KISKA_fnc_log;
    nil
};

private _overallMap = [
    localNamespace,
    "KISKA_trackArea_globalMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _trackAreaInfoMap = _overallMap get _trackAreaId;
if (isNil "_trackAreaInfoMap") exitWith {
    [["_trackAreaId ",_trackAreaId," does not exist"],true] call KISKA_fnc_log;
    nil
};

private _areas = _trackAreaInfoMap getOrDefaultCall ["areas",{[]},true];
_areas pushBackUnique _area;


nil
