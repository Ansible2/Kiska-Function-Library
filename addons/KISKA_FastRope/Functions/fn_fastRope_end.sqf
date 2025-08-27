/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_end

Description:
    Handles much of the cleanup of a fastrope in the event that the helicopter
     should cease the fastrope or has dropped off all the units.

Parameters:
    0: _fastRopeInfoMap <HASHMAP> - The hashmap that contains various pieces
        of information pertaining to the given fastrope instance.

Returns:
    NOTHING

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_end";

#define TIME_TILL_FRIES_DELETED 10
#define TIME_TILL_NORMAL_END 2
#define FALLING_ROPE_MASS 1000
#define TIME_UNTIL_ROPE_DELETION 20

params ["_fastRopeInfoMap"];

if (_fastRopeInfoMap getOrDefaultCall ["_queuedEnd", {false}]) exitWith {};

private _pilot = _fastRopeInfoMap getOrDefaultCall ["_pilot", {objNull}];
if (alive _pilot) then {
    [_pilot,"MOVE"] remoteExecCall ["enableAI",_pilot];
};

/* ----------------------------------------------------------------------------
    Disconnect ropes
---------------------------------------------------------------------------- */
private _ropeInfoMaps = _fastRopeInfoMap getOrDefaultCall ["_ropeInfoMaps", {[]}];
_ropeInfoMaps apply {
    if (_x getOrDefaultCall ["_isDisconnected",{false}]) then { continue };

    [_x] call KISKA_fnc_fastRope_ropeAttachedUnit;
    // Delete hook and top so rope falls
    deleteVehicle [
        _x getOrDefaultCall ["_hook",{objNull}],
        _x getOrDefaultCall ["_ropeTop",{objNull}]
    ];
                    
    // Give rope some extra mass to fall quick
    private _unitAttachmentDummy = _x getOrDefaultCall ["_unitAttachmentDummy",{objNull}];
    [_unitAttachmentDummy, FALLING_ROPE_MASS] remoteExec ["setMass",_unitAttachmentDummy];

    [
        {deleteVehicle _this}, 
        [
            _x getOrDefaultCall ["_ropeBottom",{objNull}], 
            _unitAttachmentDummy
        ], 
        TIME_UNTIL_ROPE_DELETION
    ] call CBA_fnc_waitAndExecute;
    
    _x set ["_isDisconnected",true];
};


/* ----------------------------------------------------------------------------
    Delete Fries
---------------------------------------------------------------------------- */
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

_fastRopeInfoMap set ["_queuedEnd",true];

/* ----------------------------------------------------------------------------
    Mark fast rope as ended
---------------------------------------------------------------------------- */
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

