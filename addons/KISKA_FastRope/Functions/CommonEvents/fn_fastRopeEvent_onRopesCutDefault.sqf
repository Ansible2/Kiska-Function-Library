/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_onRopesCutDefault

Description:
    The default behaviour for when a fastroping vehicle has severed connection
     to the ropes.
    
    The default behaviour is to attempt to close any doors of the vehicle and
     retract the hooks of the fries system. This is targetted at vanilla vehicles.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from.

Returns:
    NOTHING

Examples:
    (begin example)
        _vehicle call KISKA_fnc_fastRopeEvent_onRopesCutDefault;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_onRopesCutDefault";

params ["_vehicle"];

private _fries = _vehicle getVariable ["KISKA_fastRope_fries",objNull];
if !(isNull _fries) exitWith {
    ["extendHookRight", "extendHookLeft"] apply {
        _fries animateSource [_x, 0];
    };

    [
        {
            params ["_vehicle"];

            [
                "door_R", 
                "door_L", 
                "CargoRamp_Open", 
                "Door_rear_source", 
                "Door_6_source", 
                "CargoDoorR", 
                "CargoDoorL"
            ] apply { _vehicle animateDoor [_x, 0]; };

            ["dvere1_posunZ", "dvere2_posunZ", "doors"] apply {
                _vehicle animateSource [_x, 0];
            };
        }, 
        _vehicle, 
        2
    ] call CBA_fnc_waitAndExecute;
};

[
    "door_R", 
    "door_L", 
    "CargoRamp_Open", 
    "Door_rear_source", 
    "Door_6_source", 
    "CargoDoorR", 
    "CargoDoorL"
] apply { _vehicle animateDoor [_x, 0]; };

["dvere1_posunZ", "dvere2_posunZ", "doors"] apply {
    _vehicle animateSource [_x, 0];
};


nil
