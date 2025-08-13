// TODO: header comment
#define ROPE_TOP_INDEX 1
#define ROPE_BOTTOM_INDEX 2
#define ROPE_UNIT_ATTACHMENT_DUMMY_INDEX 3
#define ROPE_HOOK_INDEX 4
#define ROPE_IS_OCCUPIED_INDEX 5
#define ROPE_IS_BROKEN_INDEX 6

#define ROPE_UNWIND_SPEED 6
#define ATTACH_TO_DUMMY_COORDS [0, 0, -1.45]
#define ON_GROUND_BUFFER 0.2
#define ATTACHMENT_DUMMY_DOWNWARD_MASS 80
#define TIME_UNTIL_ROPE_DELETION 20
#define FALLING_ROPE_MASS 1000

scriptName "KISKA_fnc_fastRope_dropUnits";

params [
    ["_vehicle",objNull,[objNull]],
    ["_unitsToDeploy",[],[[]]],
    ["_isRecursiveCall",false,[true]]
];

if !(_isRecursiveCall) exitWith {
    if !(alive _vehicle) exitWith {};

    private _pilot = currentPilot _vehicle;
    [_pilot,"MOVE"] remoteExec ["disableAI",_pilot];
    _vehicle setVariable ["KISKA_fastRope_pilot",_pilot];

    [_vehicle, _unitsToDeploy, true] call KISKA_fnc_fastRope_dropUnits;
};


private _ropeDetailArrays = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfo",[]];
private _indexOfUnoccupiedRope = _ropeDetailArrays findIf {
    !(_x select ROPE_IS_OCCUPIED_INDEX) AND 
    { !(_x select ROPE_IS_BROKEN_INDEX) }
};
if (_indexOfUnoccupiedRope isEqualTo -1) exitWith { 
    hint "ERROR, COULDNT FIND ROPE";
    // TODO: better error
};

/* ----------------------------------------------------------------------------
    Drop Unit
---------------------------------------------------------------------------- */
private _unoccupiedRopeInfo = _ropeDetailArrays select _indexOfUnoccupiedRope;
private _unit = _unitsToDeploy deleteAt 0;
if ((alive _unit) AND {_unit in _vehicle}) then {
    _unoccupiedRopeInfo set [ROPE_IS_OCCUPIED_INDEX,true];
    unassignVehicle _unit;
    [_unit] allowGetIn false;

    [
        {
            params ["_args","_pfhHandle"];
            private _unit = _args select 0;
            // wait for unit to be outside of vehicle
            if !(isNull (objectParent _unit)) exitWith {};
            
            private _ropeInfo = _args select 1;
            private _hook = _ropeInfo select ROPE_HOOK_INDEX;
            // TODO: check if rope cut
            // Prevent teleport if hook has been deleted due to rope cut
            if (isNull _hook) exitWith {
                detach _unit;
                _ropeInfo set [ROPE_IS_OCCUPIED_INDEX,false];
                [_unit,[0,0,1]] remoteExecCall ["setVectorUp",_unit];
                [_pfhHandle] call CBA_fnc_removePerFrameHandler;
            };

            private _vehicle = _args select 2;
            private _ropeLength = _vehicle getVariable "KISKA_fastRope_ropeLength";
            private _ropeUnitAttachmentDummy = _ropeInfo select ROPE_UNIT_ATTACHMENT_DUMMY_INDEX;
            // Move unit down rope
            if (
                (getMass _ropeUnitAttachmentDummy) isNotEqualTo ATTACHMENT_DUMMY_DOWNWARD_MASS
            ) exitWith {
                // Fix for twitchyness
                [
                    "UpdateAttachmentDummyMass",
                    [_ropeUnitAttachmentDummy,getPosASLVisual _hook]
                ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];
            
                // TODO: why unwind more?
                private _ropeTop = _ropeInfo select ROPE_TOP_INDEX;
                [
                    [_ropeInfo select ROPE_TOP_INDEX, _ropeLength],
                    [_ropeInfo select ROPE_BOTTOM_INDEX, 0.5]
                ] apply {
                    _x params ["_rope","_unwindLength"];
                    [
                        [_rope, ROPE_UNWIND_SPEED, _unwindLength]
                    ] remoteExec ["ropeUnwind",_rope];
                };
            };

            private _unitWasAttachedToRope = _unit getVariable ["KISKA_fastRope_attachedToRope",false];
            if !(_unitWasAttachedToRope) then {
                _unit setVariable ["KISKA_fastRope_attachedToRope",true];
                
                [
                    _ropeUnitAttachmentDummy,
                    _unit
                ] remoteExec ["disableCollisionWith",[_ropeUnitAttachmentDummy,_unit]];
                _unit attachTo [_ropeUnitAttachmentDummy, ATTACH_TO_DUMMY_COORDS];
                
                [
                    "StartFastRopeAnimation",
                    _unit
                ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_unit];

                [
                    "StartAttachmentDescentLoop",
                    _ropeUnitAttachmentDummy
                ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];
            };

            if (_unitWasAttachedToRope AND {isNull (attachedTo _unit)}) exitWith {
                _ropeInfo set [ROPE_IS_OCCUPIED_INDEX,false];
                [_pfhHandle] call CBA_fnc_removePerFrameHandler;
            };

            private _ropeTop = _ropeInfo select ROPE_TOP_INDEX;
            private _reachedGround = ((getPosVisual _unit) select 2) < ON_GROUND_BUFFER;
            if (
                _reachedGround OR
                { (ropeLength _ropeTop) isEqualTo _ropeLength } OR
                { vectorMagnitude (velocity _vehicle) > 5 } OR
                { !((lifeState _unit) in ["HEALTHY", "INJURED"]) }
            ) exitWith {
                detach _unit;

                [
                    "EndAttachmentDescentLoop",
                    [_ropeUnitAttachmentDummy,getPosASLVisual _hook]
                ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];

                [
                    "EndFastRopeAnimation",
                    [_unit,_reachedGround]
                ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_unit];

                // TODO: Why recreate the rope???
                // So that each rope can unwind 
                deleteVehicle [
                    _ropeTop,
                    (_ropeInfo select ROPE_BOTTOM_INDEX)
                ];
                private _newRopes = [
                    _vehicle,
                    _ropeUnitAttachmentDummy,
                    _hook,
                    _ropeLength                    
                ] call KISKA_fnc_fastRope_createRope;
                _ropeInfo set [ROPE_TOP_INDEX,_newRopes select 0];
                _ropeInfo set [ROPE_BOTTOM_INDEX,_newRopes select 1];
                _ropeInfo set [ROPE_IS_OCCUPIED_INDEX,false];
                
                [_pfhHandle] call CBA_fnc_removePerFrameHandler;
            };

        }, 
        0, 
        [_unit,_unoccupiedRopeInfo,_vehicle]
    ] call CBA_fnc_addPerFrameHandler;
    moveOut _unit;
};

/* ----------------------------------------------------------------------------
    Check for recursion end
---------------------------------------------------------------------------- */
if (_unitsToDeploy isEqualTo []) exitWith {
    [
        {
            private _ropeDetailArrays = _this select 1;
            private _indexOfOccupiedRope = _ropeDetailArrays findIf {_x select ROPE_IS_OCCUPIED_INDEX};
            private _noRopesInOccupied = _indexOfOccupiedRope isEqualTo -1;
            _noRopesInOccupied
        },
        {
            params ["_vehicle","_ropeDetailArrays"];

            private _pilot = _vehicle getVariable ["KISKA_fastRope_pilot",objNull];
            if (alive _pilot) then {
                [_pilot,"MOVE"] remoteExecCall ["enableAI",_pilot];
            };
            
            _ropeDetailArrays apply {
                _x params ["","_ropeTop","_ropeBottom","_ropeUnitAttachmentDummy","_hook"];
                
                // Knock unit off rope if occupied
                if (_x select ROPE_IS_OCCUPIED_INDEX) then {
                    private _attachedObjects = attachedObjects _ropeUnitAttachmentDummy;
                    // Rope is considered occupied when it's broken as well, so check if array is empty
                    // Note: ropes are not considered attached objects by Arma
                    if (_attachedObjects isNotEqualTo []) then {
                        detach (_attachedObjects select 0);
                    };
                };

                // Delete hook and top so rope falls
                deleteVehicle [_hook,_ropeTop];

                // Give rope some extra mass to fall quick
                [
                    _ropeUnitAttachmentDummy,
                    FALLING_ROPE_MASS
                ] remoteExec ["setMass",_ropeUnitAttachmentDummy];

                [
                    {deleteVehicle _this}, 
                    [_ropeBottom, _ropeUnitAttachmentDummy], 
                    TIME_UNTIL_ROPE_DELETION
                ] call CBA_fnc_waitAndExecute;
            };

            _vehicle setVariable ["KISKA_fastRope_pilot",nil];
            
            // TODO: use function?
            _vehicle setVariable ["KISKA_fastRope_unitsDroppedOff",true];
        },
        0.25,
        [_vehicle,_ropeDetailArrays]
    ] call KISKA_fnc_waitUntil;
};


/* ----------------------------------------------------------------------------
    Wait to drop next unit
---------------------------------------------------------------------------- */
[
    {
        // TODO: handle all ropes broken
        // TODO: handle vehicle dead
        private _ropeDetailArrays = _this select 2;
        private _indexOfUnoccupiedRope = _ropeDetailArrays findIf {
            !(_x select ROPE_IS_OCCUPIED_INDEX) AND 
            { !(_x select ROPE_IS_BROKEN_INDEX) }
        };

        _indexOfUnoccupiedRope isNotEqualTo -1 // true = unoccupied rope found
    },
    {
        params ["_vehicle","_unitsToDeploy"];
        // using this buffer so that if there are multiple ropes
        // units don't look so much like they are dropping in perfect unison
        private _deployBuffer = random [0, 0.5, 1];
        [
            { _this call KISKA_fnc_fastRope_dropUnits },
            [_vehicle, _unitsToDeploy, true],
            _deployBuffer
        ] call CBA_fnc_waitAndExecute;
    },
    0.25,
    [_vehicle,_unitsToDeploy,_ropeDetailArrays]
] call KISKA_fnc_waitUntil;


nil
