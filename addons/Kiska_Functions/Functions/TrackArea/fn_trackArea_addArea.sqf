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
