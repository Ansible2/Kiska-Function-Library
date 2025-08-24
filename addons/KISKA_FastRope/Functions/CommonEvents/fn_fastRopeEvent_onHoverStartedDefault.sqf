/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_onHoverStartedDefault

Description:
    The default behaviour for when a fastroping vehicle begins hovering over the
     drop zone. Most of this logic is pulled from ACE.
    
    The default behaviour is to not allow the helicopter to deploy ropes until
     the doors are open and the FRIES hooks are extended. This is designed to
     work primarily with vanilla helicopters. The idea is to manage animations
     that should be conducted before the ropes are deployed.

Parameters:
    0: _fastRopeInfoMap <HASHMAP> - The hashmap that contains various pieces
        of information pertaining to the given fastrope instance.

Returns:
    NOTHING

Examples:
    (begin example)
        _fastRopeInfoMap call KISKA_fnc_fastRopeEvent_onHoverStartedDefault;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_onHoverStartedDefault";

params ["_fastRopeInfoMap"];

private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle",{objNull}];
if !(alive _vehicle) exitWith {};

[
    "door_R", 
    "door_L", 
    "CargoRamp_Open", 
    "Door_rear_source", 
    "Door_6_source", 
    "CargoDoorR", 
    "CargoDoorL"
] apply { _vehicle animateDoor [_x, 1]; };

["dvere1_posunZ", "dvere2_posunZ", "doors"] apply {
    _vehicle animateSource [_x, 1];
};

private _fries = _fastRopeInfoMap getOrDefaultCall ["_fries",{objNull}];
private _waitTime = 2;
if (!(isNull _fries) AND {_fries isNotEqualTo _vehicle}) then {
    [
        {
            params ["_fries"];
            ["extendHookRight", "extendHookLeft"] apply {
                _fries animateSource [_x, 1];
            };
        },
        [_fries],
        2
    ] call CBA_fnc_waitAndExecute;
    
    _waitTime = 4;
};

[
    { _this set ["_canDeployRopes",true] },
    _fastRopeInfoMap,
    _waitTime
] call CBA_fnc_waitAndExecute;


nil
