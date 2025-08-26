/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_deployRopes

Description:
    Creates ropes and deploys them from either the FRIES system or the vehicle
     from the given `_ropeOrigins`.
    
    A HASHMAP[] of information about each rope deployed from all origins (in order)
     will be placed into the `_ropeInfoMaps` key of the `_fastRopeInfoMap`.

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
scriptName "KISKA_fnc_fastRope_deployRopes";

#define ROPE_HOOK_OBJECT_CLASS "KISKA_FastRope_helper"
#define HELPER_OBJECT_CLASS "KISKA_FastRope_helper"
#define ROPE_UNWIND_SPEED 30
#define ROPE_LENGTH_BUFFER 5

params ["_fastRopeInfoMap"];

private _fries = _fastRopeInfoMap get "_fries";
private _ropeLength = (_fastRopeInfoMap get "_hoverHeight") + ROPE_LENGTH_BUFFER;
_fastRopeInfoMap set ["_ropeLength",_ropeLength];

private _ropeInfoMaps = (_fastRopeInfoMap get "_ropeOrigins") apply {
    private _hook = ROPE_HOOK_OBJECT_CLASS createVehicle [0,0,0];
    _hook allowDamage false;
    if (_x isEqualType []) then {
        _hook attachTo [_fries,_x];
    } else {
        _hook attachTo [_fries,[0,0,0],_x];
    };

    // using dummy objects with the hooks so that the ropes
    // can unwind. Otherwise, they'd need to be attached to
    // something on the ground instantly at the time of creation
    // and be their full length.
    private _unitAttachmentDummy = createVehicle [
        HELPER_OBJECT_CLASS,
        ((getPosATL _hook) vectorAdd [0,0,-1]),
        [],
        0,
        "CAN_COLLIDE"
    ];
    _unitAttachmentDummy allowDamage false;
    [
        _unitAttachmentDummy,
        _vehicle
    ] remoteExec ["disableCollisionWith",[_vehicle,_unitAttachmentDummy]];
    
    private _ropeInfoMap = createHashMapFromArray [
        ["_hook",_hook],
        ["_unitAttachmentDummy",_unitAttachmentDummy],
        ["_isOccupied",false],
        ["_isBroken",false],
        ["_fastRopeInfoMap",_fastRopeInfoMap]
    ];
    private _ropes = [_ropeInfoMap] call KISKA_fnc_fastRope_createRope;
    private _ropeBottom = _ropes select 1;
    ropeUnwind [_ropeBottom, ROPE_UNWIND_SPEED, _ropeLength, false];


    _ropeInfoMap
};

_fastRopeInfoMap set ["_ropeInfoMaps",_ropeInfoMaps];


nil
