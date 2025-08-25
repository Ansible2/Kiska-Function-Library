// TODO: document
scriptName "KISKA_fnc_fastRope_end";

#define TIME_TILL_FRIES_DELETED 10
#define TIME_TILL_NORMAL_END 2

params ["_fastRopeInfoMap"];

private _ropeInfoMaps = _fastRopeInfoMap getOrDefaultCall ["_ropeInfoMaps", {[]}];
_ropeInfoMaps call KISKA_fnc_fastRope_disconnectRopes;

private _pilot = _fastRopeInfoMap getOrDefaultCall ["_pilot", {objNull}];
if (alive _pilot) then {
    [_pilot,"MOVE"] remoteExecCall ["enableAI",_pilot];
};

private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle", {objNull}];
private _fries = _fastRopeInfoMap getOrDefaultCall ["_fries", {objNull}];
if (
    !(isNull _fries) AND 
    {_fries isNotEqualTo _vehicle}
) then {
    // TODO: there has to be a more robust way of allowing
    // this to be used in the onDropEnd event and deleted here...
    [
        { deleteVehicle _this },
        [_fries],
        TIME_TILL_FRIES_DELETED
    ] call CBA_fnc_waitAndExecute;
};


if !(alive _vehicle) exitWith {
    _fastRopeInfoMap set ["_fastRopeEnded",true];
};
// waiting to say the drop is over to give the cut ropes time
// to fall. In tome cases, the rope might clip with the helicopter
// while moving and cause damage and/or get stuck to the helicopter and clip
[
    {
        (_this select 0) set ["_fastRopeEnded",true];
    },
    [_fastRopeInfoMap],
    TIME_TILL_NORMAL_END
] call CBA_fnc_waitAndExecute;

