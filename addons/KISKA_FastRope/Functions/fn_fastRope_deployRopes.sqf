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
    private _ropeAttachmentDummy = createVehicle [
        HELPER_OBJECT_CLASS,
        ((getPosATL _hook) vectorAdd [0,0,-1]),
        [],
        0,
        "CAN_COLLIDE"
    ];
    _ropeAttachmentDummy allowDamage false;
    _ropeAttachmentDummy disableCollisionWith _vehicle; // TODO: remote exec onto where vehicle is local too? This whole function should probably be executed on where the vehicle is local tbh
    
    // TODO: why is there a ropeTop and a ropeBottom and why do we need
    // dummy objects? It seems like all you need is ropeBottom
    private _ropeTop = ropeCreate [_ropeAttachmentDummy, [0, 0, 0], _hook, [0, 0, 0], 0.5];
    private _ropeBottom = ropeCreate [_ropeAttachmentDummy, [0, 0, 0], 1];
    ropeUnwind [_ropeBottom, ROPE_UNWIND_SPEED, _hoverHeight + ROPE_LENGTH_BUFFER, false];

    [
        _ropeTop,
        "RopeBreak",
        {
            params ["_rope"];
            _thisArgs params ["_vehicle", "_ropeAttachmentDummy"];
            private _brokenRopeInfo = [_rope,_vehicle] call KISKA_fnc_fastRopeEvent_onRopeBreak;

            if !(isNil "_brokenRopeInfo") then {
                private _unitOnRope = (attachedObjects _ropeAttachmentDummy) findIf {
                    _x isKindOf "CAManBase"
                };
                detach _unitOnRope;
            };
        },
        [_vehicle,_ropeAttachmentDummy]
    ] call CBA_fnc_addBISEventHandler;

    [
        _ropeTop,
        "RopeBreak",
        {
            params ["_rope"];
            _thisArgs params ["_vehicle"];
            [_rope,_vehicle] call KISKA_fnc_fastRopeEvent_onRopeBreak;
        },
        [_vehicle]
    ] call CBA_fnc_addBISEventHandler;

    // TODO: make hashmap?
    _deployedRopeInfo pushBack [
        _x,
        _ropeTop,
        _ropeBottom,
        _ropeAttachmentDummy,
        _hook,
        false, // rope occupied
        false // rope broken
    ];

    _ropeBottom
};


