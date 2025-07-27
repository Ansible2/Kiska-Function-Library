/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_getRopeOrigins

Description:
    Gets the configured rope origins for a particular vehicle/class. This will 
     default to the `"CfgVehicles" >> VEHICLE_TYPE >> "KISKA_fastRope" >> "ropeOrigins"`
     path (can be defined in either the `missionConfigFile`, `campaignConfigFile`, 
     or the `configFile`).

    If no rope origins are found in a `KISKA_fastRope` class, any configuration for ace
     (`configFile >> "CfgVehicles" >> VEHICLE_TYPE >> "ace_fastroping_ropeOrigins") will
     be used if defined.

Parameters:
    0: _vehicleConfig <OBJECT | CONFIG> - The vehicle that a fastrope will be conducted
        from or its config path.

Returns:
    <(STRING | PositionRelative[])[]> - An array of relative positions and/or memory
        points that are where ropes should be attached to the vehicle class.

Examples:
    (begin example)
        private _ropeOrigins = (configOf MyVehicle) call KISKA_fnc_fastRopeEvent_getRopeOrigins;
    (end)

    (begin example)
        private _ropeOrigins = MyVehicle call KISKA_fnc_fastRopeEvent_getRopeOrigins;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_getRopeOrigins";

#define ROPE_ORIGINS_KEY "ropeOrigins"

params [
    ["_vehicleConfig",configNull,[configNull,objNull]]
];

if (isNull _vehicleConfig) exitWith { [] };

private _vehicleDataCacheMap = _vehicleConfig call KISKA_fnc_fastRopeEvent_getDataCacheMap;
private _ropeOrigins = _vehicleDataCacheMap get ROPE_ORIGINS_KEY;

if !(isNil "_ropeOrigins") exitWith { _ropeOrigins };


if (_vehicleConfig isEqualType objNull) then {
    _vehicleConfig = configOf _vehicleConfig;
};
_ropeOrigins = [[
    "CfgVehicles",
    configName _vehicleConfig,
    "KISKA_fastRope",
    ROPE_ORIGINS_KEY
]] call KISKA_fnc_findConfigAny;

if ( (isNil "_ropeOrigins") OR {_ropeOrigins isEqualType []} ) then {
    _ropeOrigins = getArray(_vehicleConfig >> "ace_fastroping_ropeOrigins");
};
_vehicleDataCacheMap set [ROPE_ORIGINS_KEY, _ropeOrigins];


_ropeOrigins

