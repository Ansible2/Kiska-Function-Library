/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_deployRopes

Description:
    Creates ropes and deploys them from either the FRIES system or the vehicle
     from the given `_ropeOrigins`.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from.
    1: _ropeOrigins <(STRING | PositionRelative[])[]> - An array of relative 
        (to the FRIES system or vehicle if no FRIES system is used) attachment points 
        for the ropes and/or memory points to `attachTo` the ropes to the vehicle.
    2: _hoverHeight <NUMBER> - The height the helicopter should hover above the 
        drop position while units are fastroping.

Returns:
    <OBJECT[]> - An array of ropes deployed from each rope origin.

Examples:
    (begin example)
        [
            _vehicle,
            ["ropeOriginRight","ropeOriginLeft"],
            20
        ] call KISKA_fnc_fastRope_deployRopes;
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

params [
    ["_vehicle",objNull,[objNull]],
    ["_ropeOrigins",[],[[]]],
    ["_hoverHeight",5,[123]]
];

// defaults to vehicle in case there isn't a bespoke fries system
private _fries = _vehicle call KISKA_fnc_fastRope_fries;
private _deployedRopeInfoMaps = [];
_vehicle setVariable ["KISKA_fastRope_deployedRopeInfoMaps",_deployedRopeInfoMaps];
private _ropeLength = _hoverHeight + ROPE_LENGTH_BUFFER;
_vehicle setVariable ["KISKA_fastRope_ropeLength",_ropeLength];

_ropeOrigins apply {
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
        ["_isBroken",false]
    ];
    _deployedRopeInfoMaps pushBack _ropeInfoMap;
    private _ropes = [_vehicle,_ropeInfoMap] call KISKA_fnc_fastRope_createRope;
    private _ropeBottom = _ropes select 1;
    ropeUnwind [_ropeBottom, ROPE_UNWIND_SPEED, _ropeLength, false];


    _ropeBottom
};
