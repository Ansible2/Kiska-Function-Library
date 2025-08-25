/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_dropUnits

Description:
    Drops the units from the aircraft using fastropes. Will recursively call
     itself until all the units are dropped.

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
scriptName "KISKA_fnc_fastRope_dropUnits";

#define ROPE_UNWIND_SPEED 6
#define ON_GROUND_BUFFER 0.2
#define ATTACHMENT_DUMMY_DOWNWARD_MASS 80

params [
    "_fastRopeInfoMap",
    ["_isRecursiveCall",false,[true]]
];

if !(_isRecursiveCall) exitWith {
    private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle",{objNull}];
    if !(alive _vehicle) exitWith {
        _fastRopeInfoMap call KISKA_fnc_fastRope_end;
        nil
    };

    private _pilot = currentPilot _vehicle;
    [_pilot,"MOVE"] remoteExec ["disableAI",_pilot];
    _fastRopeInfoMap set ["_pilot",_pilot];
    private _ropeInfoMaps = _fastRopeInfoMap get "_ropeInfoMaps";
    _fastRopeInfoMap set ["_unoccupiedRopeInfoMap",_ropeInfoMaps select 0];
    [_fastRopeInfoMap, true] call KISKA_fnc_fastRope_dropUnits;
};


/* ----------------------------------------------------------------------------
    Drop Unit
---------------------------------------------------------------------------- */
private _unoccupiedRopeInfoMap = _fastRopeInfoMap get "_unoccupiedRopeInfoMap";
private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle",{objNull}];
private _unitsToDeploy = _fastRopeInfoMap getOrDefaultCall ["_unitsToDeploy",{[]}];
private _unit = _unitsToDeploy deleteAt 0;
if ((alive _unit) AND {_unit in _vehicle}) then {
    _unoccupiedRopeInfoMap set ["_isOccupied",true];
    unassignVehicle _unit;
    [_unit] allowGetIn false;

    [
        {
            // TODO: handle dead vehicle
            // TODO: handle vehicle engine died
            // TODO: clearer handling of what happens in this loop if the rope breaks



            #define PER_FRAME_HANDLER_ID _this select 1

            params ["_args"];
            private _unit = _args select 0;
            // wait for unit to be outside of vehicle
            if !(isNull (objectParent _unit)) exitWith {};
            
            private _ropeInfoMap = _args select 1;
            private _hook = _ropeInfoMap getOrDefaultCall ["_hook",{objNull}];
            // Prevent teleport if hook has been deleted due to rope cut
            if (isNull _hook) exitWith {
                [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;
                _unit setVariable ["KISKA_fastRope_attachedToRope",nil];

                [_unit,[0,0,1]] remoteExecCall ["setVectorUp",_unit];
                [PER_FRAME_HANDLER_ID] call CBA_fnc_removePerFrameHandler;
            };

            private _ropeUnitAttachmentDummy = _ropeInfoMap getOrDefaultCall ["_unitAttachmentDummy",{objNull}];
            private _vehicle = _args select 2;
            private _ropeLength = _args select 3;
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
                [
                    [_ropeInfoMap get "_ropeTop", _ropeLength],
                    [_ropeInfoMap get "_ropeBottom", 0.5]
                ] apply {
                    _x params ["_rope","_unwindLength"];
                    [ [_rope, ROPE_UNWIND_SPEED, _unwindLength] ] remoteExec ["ropeUnwind",_rope];
                };
            };

            private _unitWasAttachedToRope = _unit getVariable ["KISKA_fastRope_attachedToRope",false];
            if !(_unitWasAttachedToRope) then {
                [
                    _ropeUnitAttachmentDummy,
                    _unit
                ] remoteExec ["disableCollisionWith",[_ropeUnitAttachmentDummy,_unit]];

                [_ropeInfoMap,_unit] call KISKA_fnc_fastRope_ropeAttachedUnit;
                _unit setVariable ["KISKA_fastRope_attachedToRope",true];
                
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
                [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;
                [PER_FRAME_HANDLER_ID] call CBA_fnc_removePerFrameHandler;
            };

            private _ropeTop = _ropeInfoMap get "_ropeTop";
            private _reachedGround = ((getPosVisual _unit) select 2) < ON_GROUND_BUFFER;
            if (
                _reachedGround OR
                { (ropeLength _ropeTop) isEqualTo _ropeLength } OR
                { vectorMagnitude (velocity _vehicle) > 5 } OR
                { !((lifeState _unit) in ["HEALTHY", "INJURED"]) }
            ) exitWith {
                [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;
                _unit setVariable ["KISKA_fastRope_attachedToRope",nil];

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
                    (_ropeInfoMap get "_ropeBottom")
                ];
                [_ropeInfoMap,_ropeLength] call KISKA_fnc_fastRope_createRope;
                
                [PER_FRAME_HANDLER_ID] call CBA_fnc_removePerFrameHandler;
            };
        }, 
        0, 
        [_unit, _unoccupiedRopeInfoMap, _vehicle, _fastRopeInfoMap get "_ropeLength"]
    ] call CBA_fnc_addPerFrameHandler;
    moveOut _unit;
};

/* ----------------------------------------------------------------------------
    Check for recursion end
---------------------------------------------------------------------------- */
_fastRopeInfoMap set ["_unoccupiedRopeInfoMap",nil];
if (_unitsToDeploy isEqualTo []) exitWith {
    [
        {
            // TODO: handle engine dying
            if (
                !(alive (_this select 0)) OR
                { (_this select 2) getOrDefaultCall ["_allRopesBroken",{false},true] }
            ) exitWith { true };

            private _indexOfOccupiedRope = (_this select 1) findIf { 
                _x getOrDefaultCall ["_isOccupied",{false}] 
            };
            _indexOfOccupiedRope isEqualTo -1 // no ropes occupied
        },
        {
            (_this select 2) call KISKA_fnc_fastRope_end;
        },
        0.25,
        [_vehicle,_ropeInfoMaps,_fastRopeInfoMap]
    ] call KISKA_fnc_waitUntil;

    nil
};


/* ----------------------------------------------------------------------------
    Wait to drop next unit
---------------------------------------------------------------------------- */
[
    {
        // TODO: handle engine dying
        private _fastRopeInfoMap = _this select 2;
        if (
            !(alive (_this select 0)) OR
            { _fastRopeInfoMap getOrDefaultCall ["_allRopesBroken",{false},true] }
        ) exitWith { true };

        private _continue = false;
        (_this select 1) apply {
            if (
                !(_x getOrDefaultCall ["_isOccupied", {false}]) AND 
                { !(_x getOrDefaultCall ["_isBroken", {false}]) }
            ) then {
                _fastRopeInfoMap set ["_unoccupiedRopeInfoMap",_x];
                break;
            };
        };

        _continue
    },
    {
        private _fastRopeInfoMap = _this select 2;
        private _unoccupiedRopeInfoMap = _fastRopeInfoMap get "_unoccupiedRopeInfoMap";
        private _vehicleIsDeadOrRopesBroke = isNil "_unoccupiedRopeInfoMap";
        if (_vehicleIsDeadOrRopesBroke) exitWith {
            _fastRopeInfoMap call KISKA_fnc_fastRope_end;
            nil
        };

        // using this buffer so that if there are multiple ropes
        // units don't look so much like they are dropping in perfect unison
        private _deployBuffer = random [0, 0.5, 1];
        [
            { _this call KISKA_fnc_fastRope_dropUnits },
            [_fastRopeInfoMap, true],
            _deployBuffer
        ] call CBA_fnc_waitAndExecute;
    },
    0.25,
    [_vehicle,_ropeInfoMaps,_fastRopeInfoMap]
] call KISKA_fnc_waitUntil;


nil
