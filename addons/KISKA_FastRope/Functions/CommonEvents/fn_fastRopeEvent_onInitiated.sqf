scriptName "KISKA_fnc_fastRopeEvent_onInitiated";

#define ON_INITIATED_KEY "onInitiated"

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

private _vehicleConfig = configOf _vehicle;
private _vehicleDataCacheMap = _vehicleConfig call KISKA_fnc_fastRopeEvent_getDataCacheMap;

private _onInitiated = _vehicleDataCacheMap get ON_INITIATED_KEY;
if !(isNil "_onInitiated") exitWith { _vehicle call _onInitiated };

_onInitiated = [[
    "CfgVehicles",
    configName _vehicleConfig,
    "KISKA_fastRope",
    ON_INITIATED_KEY
]] call KISKA_fnc_findConfigAny;

if ( !(isNil "_onInitiated") AND {_onInitiated isEqualType ""} ) exitWith {
    _onInitiated = compile _onInitiated;
    _vehicleDataCacheMap set [ROPE_ORIGINS_KEY, _onInitiated];
    _vehicle call _onInitiated;
    nil
};


// TODO: how to attach KISKA fries but also be compatible with ACE?
