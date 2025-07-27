/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_getDataCacheMap

Description:
    Gets a map that collects any constant data related to the fastrope system
    and a specific vehicle config.

Parameters:
    0: _vehicleConfig <OBJECT | CONFIG> - The vehicle that a fastrope will be conducted
        from or its config path.

Returns:
    <HASHMAP | NIL> - a hashmap containing any constant information that pertains to
        the fastrope system for a particular vehicle type (config):

    - `ropeOrigins`: <(STRING | Vector3D[])[]> - List of relative vectors or memory points 
        to attach ropes to.

Examples:
    (begin example)
        private _cacheMap = (configOf MyVehicle) call KISKA_fnc_fastRopeEvent_getDataCacheMap;
        private _ropeOrigins = _cacheMap get "ropeOrigins";
    (end)

    (begin example)
        private _cacheMap = MyVehicle call KISKA_fnc_fastRopeEvent_getDataCacheMap;
        private _ropeOrigins = _cacheMap get "ropeOrigins";
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_getDataCacheMap";

params [
    ["_vehicleConfig",configNull,[configNull,objNull]]
];

if (_vehicleConfig isEqualType objNull) then {
    _vehicleConfig = configOf _vehicleConfig;
};

if (isNull _vehicleConfig) exitWith {};


private _overallMap = localNamespace getVariable "KISKA_fastRope_dataCacheMap";
if (isNil "_overallMap") then {
    _overallMap = createHashMap;
    localNamespace setVariable ["KISKA_fastRope_dataCacheMap",_overallMap];
};

private _vehicleDataMap = _overallMap get _vehicleConfig;
if !(isNil "_vehicleDataMap") exitWith {_vehicleDataMap};


_vehicleDataMap = createHashMap;
_overallMap set [_vehicleConfig,_vehicleDataMap];


_vehicleDataMap
