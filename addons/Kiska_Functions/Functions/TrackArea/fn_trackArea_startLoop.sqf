scriptName "KISKA_fnc_trackArea_startLoop";

#define PER_FRAME_HANDLER_KEY "perFrameHandlerId"

params [
    ["_trackAreaId","",[""]]
];


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

if (PER_FRAME_HANDLER_KEY in _trackAreaInfoMap) exitWith {
    [["_trackAreaId ",_trackAreaId," is already started"]] call KISKA_fnc_log;
    nil
};

private _perFrameHandlerId = [
    {
        params ["_args"];
        _args params ["_trackAreaId","_trackAreaInfoMap"];

        // TODO: logic to see who's in or out


    },
    _trackAreaInfoMap getOrDefaultCall ["checkFrequency",{0},true],
    [_trackAreaId,_trackAreaInfoMap]
] call KISKA_fnc_CBA_addPerFrameHandler;


nil