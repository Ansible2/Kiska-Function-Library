// TODO: header comment
#define ROPE_HOOK_OBJECT_CLASS "KISKA_FastRope_helper"
#define HELPER_OBJECT_CLASS "KISKA_FastRope_helper"
#define ROPE_UNWIND_SPEED 30
#define ROPE_LENGTH_BUFFER 5

params [
    ["_vehicle",objNull,[objNull]],
    ["_ropeOrigins",[],[[]]],
    ["_hoverHeight",5,[123]]
];

private _fries = _vehicle getVariable ["KISKA_fastRope_fries",objNull]; // TODO: abstract this away into a function maybe?
private _deployedRopeInfo = [];
_vehicle setVariable ["KISKA_fastRope_deployedRopeInfo",_deployedRopeInfo];
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
    // TODO: remote exec onto where vehicle is local too? This whole function should probably be executed on where the vehicle is local tbh
    _unitAttachmentDummy disableCollisionWith _vehicle; 
    
    private _ropes = [] call KISKA_fnc_fastRope_createRope;
    _ropes params ["_ropeTop","_ropeBottom"];
    ropeUnwind [_ropeBottom, ROPE_UNWIND_SPEED, _ropeLength, false];


    // This isn't a hashmap because of maximizing performance in the
    // dropUnits function
    _deployedRopeInfo pushBack [
        _x,
        _ropeTop,
        _ropeBottom,
        _unitAttachmentDummy,
        _hook,
        false, // rope occupied
        false // rope broken
    ];

    _ropeBottom
};


