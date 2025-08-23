/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_fries

Description:
    Sets or gets the FRIES system that the vehicle will deploy its ropes from.

    The default is the vehicle itself.

Parameters:
    0: _vehicle <OBJECT> - The vehicle that the fries system should be attached to.
    1: _setFRIES <NIL or OBJECT> - Default: `nil` - The value to set to be the FRIES
        system. If no value is passed (`nil`) the value is unchanged and the
        current value will be returned. Defaults to the `_vehicle`. If
        the value is `objNull` the variable will be cleared.

Returns:
    <OBJECT> - The current object acting as the place to hang ropes from.

Examples:
    (begin example)
        // set fries to be MY_FRIES_OBJECT
        [VEHICLE, MY_FRIES_OBJECT] call KISKA_fnc_fastRope_fries;
    (end)

    (begin example)
        // get current value
        private _friesSystem = [VEHICLE] call KISKA_fnc_fastRope_fries;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_fries";

#define FRIES_SYSTEM_PROPERTY "KISKA_fastRope_fries"

params [
    ["_vehicle",objNull,[objNull]],
    ["_setFRIES",nil,[true]]
];

if !(alive _vehicle) exitWith { objNull };

if (isNil "_setFRIES") exitWith {
    _vehicle getVariable [FRIES_SYSTEM_PROPERTY,_vehicle]
};

if (isNull _setFRIES) exitWith {
    _vehicle setVariable [FRIES_SYSTEM_PROPERTY,nil];
    objNull
};


_vehicle setVariable [FRIES_SYSTEM_PROPERTY,_setFRIES];
_setFRIES
