/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_onDropEndedDefault

Description:
    The default behaviour for when a fastroping vehicle has either completed its
     dropping off of units or the vehicle has encountered something that caused
     the fastrope to end.
    
    The default behaviour is to attempt to close any doors of the vehicle and
     retract the hooks of the fries system. This is targetted at vanilla vehicles.

Parameters:
    0: _fastRopeInfoMap <HASHMAP> - The hashmap that contains various pieces
        of information pertaining to the given fastrope instance.

Returns:
    NOTHING

Examples:
    (begin example)
        _fastRopeInfoMap call KISKA_fnc_fastRopeEvent_onDropEndedDefault;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_onDropEndedDefault";

params ["_fastRopeInfoMap"];

private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle",{objNull}];
if !(alive _vehicle) exitWith {};

private _fries = _fastRopeInfoMap getOrDefaultCall ["_fries",{objNull}];
if (!(isNull _fries) AND {_fries isNotEqualTo _vehicle}) exitWith {
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
    ] call KISKA_fnc_CBA_waitAndExecute;
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
