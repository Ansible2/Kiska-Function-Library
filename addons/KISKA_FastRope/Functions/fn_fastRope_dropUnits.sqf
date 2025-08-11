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

params [
    ["_vehicle",objNull,[objNull]],
    ["_unitsToDeploy",[],[[]]]
];

if !(alive _vehicle) exitWith {};

private _pilot = currentPilot _vehicle;
[_pilot,"MOVE"] remoteExecCall ["disableAI",_pilot];
_vehicle setVariable ["KISKA_fastRope_pilot",_pilot];

private _fn_dropUnitLoop = {
    params ["_unit","_unoccupiedRopeInfo","_vehicle"];

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
                    ] remoteExecCall ["ropeUnwind",_rope];
                };
            };

            private _unitWasAttachedToRope = _unit getVariable ["KISKA_fastRope_attachedToRope",false];
            if !(_unitWasAttachedToRope) then {
                _unit setVariable ["KISKA_fastRope_attachedToRope",true];
                
                [
                    _ropeUnitAttachmentDummy,
                    _unit
                ] remoteExecCall ["disableCollisionWith",[_ropeUnitAttachmentDummy,_unit]];
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
        _this
    ] call CBA_fnc_addPerFrameHandler;
};

private _fn_dropUnitsRecursive = {
    params ["_vehicle","_unoccupiedRopeInfo","_unitsToDeploy"];

    private _unit = _unitsToDeploy deleteAt 0;
    if ((alive _unit) AND {_unit in _vehicle}) then {
        _unoccupiedRopeInfo set [ROPE_IS_OCCUPIED_INDEX,true];
        unassignVehicle _unit;
        [_unit] allowGetIn false;
        [_unit,_unoccupiedRopeInfo,_vehicle] call _fn_dropUnitLoop;
        moveOut _unit;
    };

    private _ropeDetailArrays = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfo",[]];
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

                    // Only delete the hook first so the rope falls down.
                    // Note: ropeDetach was used here before, but the command seems a bit broken.
                    // TODO: try ropeDetach
                    deleteVehicle _hook;
                    [
                        {deleteVehicle _this}, 
                        [_ropeTop, _ropeBottom, _dummy], 
                        60
                    ] call CBA_fnc_waitAndExecute;
                };

                _vehicle setVariable ["KISKA_fastRope_deployedRopeInfo", nil];
                _vehicle setVariable ["KISKA_fastRope_pilot",nil];
                // TODO: use function?
                _vehicle setVariable ["KISKA_fastRope_unitsDroppedOff",true];
            },
            0.25,
            [_vehicle,_ropeDetailArrays]
        ] call KISKA_fnc_waitUntil;
    };

    // [
    //     {
    //         // TODO: handle all ropes broken
    //         // TODO: handle vehicle dead
    //         private _ropes = _this select 1;
    //         private _indexOfUnoccupiedRope = _ropes findIf {
    //             !(_x select ROPE_IS_OCCUPIED_INDEX) AND 
    //             { !(_x select ROPE_IS_BROKEN_INDEX) }
    //         };
    //         if (_indexOfUnoccupiedRope isEqualTo -1) exitWith { false };
            
    //         private _unoccupiedRopeInfo = _ropes select _indexOfUnoccupiedRope;
    //         private _vehicle = _this select 0;
    //         _vehicle setVariable ["KISKA_fastRope_unoccupiedRopeInfo",_unoccupiedRopeInfo];
    //         true
    //     },
    //     {
    //         params ["_vehicle","","_unitsToDeploy","_fn_dropUnitsRecursive"];
    //         private _unoccupiedRopeInfo = _vehicle getVariable "KISKA_fastRope_unoccupiedRopeInfo";
    //         _vehicle setVariable ["KISKA_fastRope_unoccupiedRopeInfo",nil];
    //         [_vehicle,_unoccupiedRopeInfo,_unitsToDeploy] call _fn_dropUnitsRecursive;
    //     },
    //     0.25,
    //     [_vehicle,_ropes,_unitsToDeploy,_fn_dropUnitsRecursive]
    // ] call KISKA_fnc_waitUntil;
};

private _ropes = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfo",[]];
[_vehicle, _ropes select 0, _unitsToDeploy] call _fn_dropUnitsRecursive;


nil
