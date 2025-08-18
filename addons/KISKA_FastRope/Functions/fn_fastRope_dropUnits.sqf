// TODO: header comment

#define ROPE_UNWIND_SPEED 6
#define ON_GROUND_BUFFER 0.2
#define ATTACHMENT_DUMMY_DOWNWARD_MASS 80

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

private _fn_findUnoccupiedRopeIndex = {
    private _ropeInfoMaps = _this;
    _ropeInfoMaps findIf {
        !(_x getOrDefaultCall ["_isOccupied",{false}]) AND 
        { !(_x getOrDefaultCall ["_isOccupied",{false}]) }
    };
};
private _ropeInfoMaps = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfoMaps",[]];
private _indexOfUnoccupiedRope = _ropeInfoMaps call _fn_findUnoccupiedRopeIndex;
if (_indexOfUnoccupiedRope isEqualTo -1) exitWith { 
    hint "ERROR, COULDNT FIND ROPE";
    // TODO: better error
};

/* ----------------------------------------------------------------------------
    Drop Unit
---------------------------------------------------------------------------- */
private _unoccupiedRopeInfoMap = _ropeInfoMaps select _indexOfUnoccupiedRope;
private _unit = _unitsToDeploy deleteAt 0;
if ((alive _unit) AND {_unit in _vehicle}) then {
    _unoccupiedRopeInfoMap set ["_isOccupied",true];
    unassignVehicle _unit;
    [_unit] allowGetIn false;

    [
        {
            #define PER_FRAME_HANDLER_ID _this select 1

            params ["_args"];
            private _unit = _args select 0;
            // wait for unit to be outside of vehicle
            if !(isNull (objectParent _unit)) exitWith {};
            
            private _ropeInfoMap = _args select 1;
            private _hook = _ropeInfoMap getOrDefaultCall ["_hook",{objNull}];
            private _ropeUnitAttachmentDummy = _ropeInfoMap getOrDefaultCall ["_unitAttachmentDummy",{objNull}];
            // TODO: check if rope cut
            // Prevent teleport if hook has been deleted due to rope cut
            if (isNull _hook) exitWith {
                [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;
                _unit setVariable ["KISKA_fastRope_attachedToRope",nil];

                [_unit,[0,0,1]] remoteExecCall ["setVectorUp",_unit];
                [PER_FRAME_HANDLER_ID] call CBA_fnc_removePerFrameHandler;
            };

            private _vehicle = _args select 2;
            private _ropeLength = _vehicle getVariable "KISKA_fastRope_ropeLength";
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
                    _unit,
                    _ropeUnitAttachmentDummy
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
                _ropeInfoMap set ["_isOccupied",false];
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
                private _newRopes = [
                    _vehicle,
                    _ropeUnitAttachmentDummy,
                    _hook,
                    _ropeLength                    
                ] call KISKA_fnc_fastRope_createRope;
                
                [PER_FRAME_HANDLER_ID] call CBA_fnc_removePerFrameHandler;
            };

        }, 
        0, 
        [_unit,_unoccupiedRopeInfoMap,_vehicle]
    ] call CBA_fnc_addPerFrameHandler;
    moveOut _unit;
};

/* ----------------------------------------------------------------------------
    Check for recursion end
---------------------------------------------------------------------------- */
if (_unitsToDeploy isEqualTo []) exitWith {
    [
        {
            private _ropeInfoMaps = _this select 1;
            private _indexOfOccupiedRope = _ropeInfoMaps findIf {_x getOrDefaultCall ["_isOccupied",{false}]};
            private _noRopesInOccupied = _indexOfOccupiedRope isEqualTo -1;
            _noRopesInOccupied
        },
        {
            params ["_vehicle"];

            private _pilot = _vehicle getVariable ["KISKA_fastRope_pilot",objNull];
            if (alive _pilot) then {
                [_pilot,"MOVE"] remoteExecCall ["enableAI",_pilot];
            };
            

            _vehicle setVariable ["KISKA_fastRope_pilot",nil];

            // waiting to say the drop is over to give the cut ropes time
            // to fall. In tome cases, the rope might clip with the helicopter
            // while moving and cause damage and/or get stuck to the helicopter and clip
            [
                {
                    // TODO: use function?
                    (_this select 0) setVariable ["KISKA_fastRope_unitsDroppedOff",true];
                },
                [_vehicle],
                2
            ] call CBA_fnc_waitAndExecute;
        },
        0.25,
        [_vehicle,_ropeInfoMaps]
    ] call KISKA_fnc_waitUntil;
};


/* ----------------------------------------------------------------------------
    Wait to drop next unit
---------------------------------------------------------------------------- */
[
    {
        // TODO: handle all ropes broken
        // TODO: handle vehicle dead
        private _indexOfUnoccupiedRope = (_this select 2) call (_this select 3)
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
    [_vehicle,_unitsToDeploy,_ropeInfoMaps,_fn_findUnoccupiedRopeIndex]
] call KISKA_fnc_waitUntil;


nil
