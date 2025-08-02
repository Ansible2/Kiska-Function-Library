// TODO: header comment
scriptName "KISKA_fnc_fastRopeEvent_onHoverStartedDefault";

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

[_vehicle,false] call KISKA_fnc_fastRope_canDeployRopes;

[
    "door_R", 
    "door_L", 
    "CargoRamp_Open", 
    "Door_rear_source", 
    "Door_6_source", 
    "CargoDoorR", 
    "CargoDoorL",
] apply { _vehicle animateDoor [_x, 1]; };

["dvere1_posunZ", "dvere2_posunZ", "doors"] apply {
    _vehicle animateSource [_x, 1];
};

private _fries = _vehicle getVariable ["KISKA_fastRope_fries", objNull];
private _waitTime = 2;
if !(isNull _fries) then {
    ["extendHookRight", "extendHookLeft"] apply {
        _vehicle animateSource [_x, 1];
    };
    _waitTime = 4;
};

[
    {
        [_vehicle,true] call KISKA_fnc_fastRope_canDeployRopes
    },
    [],
    _waitTime
] call CBA_fnc_waitAndExecute;


nil
