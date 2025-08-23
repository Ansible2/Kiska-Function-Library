/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_areUnitsDroppedOff

Description:
    Sets or gets whether or not the given vehicle has completed its deployment
     of units for the current drop.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to check.
    1: _setDroppedOff <NIL or BOOL> - Default: `nil` - The value to set on whether
        or not the vehicle has completed the deployment. If no value is passed (`nil`),
        the value is unchanged.

Returns:
    <BOOL> - Whether or not the vehicle has deployed the units for its current drop.

Examples:
    (begin example)
        // Mark units as being dropped off
        [VEHICLE, true] call KISKA_fnc_fastRope_areUnitsDroppedOff;
    (end)

    (begin example)
        // get current value
        private _areUnitsDroppedOff = [VEHICLE] call KISKA_fnc_fastRope_areUnitsDroppedOff;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_areUnitsDroppedOff";

#define UNITS_DROPPED_PROPERTY "KISKA_fastRope_unitsDroppedOff"

params [
    ["_vehicle",objNull,[objNull]],
    ["_setDroppedOff",nil,[true]]
];

if !(alive _vehicle) exitWith { false };

if (isNil "_setDroppedOff") exitWith {
    _vehicle getVariable [UNITS_DROPPED_PROPERTY,false]
};


_vehicle setVariable [UNITS_DROPPED_PROPERTY,_setDroppedOff];
_setDroppedOff
