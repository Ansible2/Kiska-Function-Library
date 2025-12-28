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
