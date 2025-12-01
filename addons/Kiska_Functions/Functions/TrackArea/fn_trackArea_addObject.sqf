scriptName "KISKA_fnc_trackArea_addObject";

params [
    ["_trackAreaId","",[""]],
    ["_object",objNull,[objNull]]
];

if !(alive _object) exitWith {
    ["_object is not alive",true] call KISKA_fnc_log;
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

private _objects = _trackAreaInfoMap getOrDefaultCall ["trackedObjects",{[]},true];
_objects pushBackUnique _object;


nil
