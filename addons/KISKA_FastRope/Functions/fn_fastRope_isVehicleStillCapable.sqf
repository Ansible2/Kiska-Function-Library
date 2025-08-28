/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_isVehicleStillCapable

Description:
    Checks if a vehicle can still drop units after it has been told to fastrope.

    The vehicle must be alive, and its engine must be on (`isEngineOn`).
     The `_fastRopeInfoMap` must also return `false` for `_allRopesBroken`.

Parameters:
    0: _fastRopeInfoMap <HASHMAP> - The hashmap that contains various pieces
        of information pertaining to the given fastrope instance.

Returns:
    <BOOL> - Whether or not units can still fastrope from this vehicle.

Examples:
    (begin example)
        private _unitsCanStillFastRope = 
            _fastRopeInfoMap call KISKA_fnc_fastRope_isVehicleStillCapable;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_isVehicleStillCapable";

params ["_fastRopeInfoMap"];

private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle",{objNull}];

(alive _vehicle) AND
{ isEngineOn _vehicle } AND
{ !(_fastRopeInfoMap getOrDefaultCall ["_allRopesBroken",{false},true]) }
