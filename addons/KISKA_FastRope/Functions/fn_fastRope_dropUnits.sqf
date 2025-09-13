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

#define ON_GROUND_BUFFER 0.2

params [
    "_fastRopeInfoMap",
    ["_isRecursiveCall",false,[true]]
];

if (
    !(_fastRopeInfoMap call KISKA_fnc_fastRope_isVehicleStillCapable)
) exitWith {
    _fastRopeInfoMap call KISKA_fnc_fastRope_end;
    nil
};

private _vehicle = _fastRopeInfoMap getOrDefaultCall ["_vehicle",{objNull}];
private _ropeInfoMaps = _fastRopeInfoMap get "_ropeInfoMaps";
if !(_isRecursiveCall) exitWith {
    private _pilot = currentPilot _vehicle;
    [_pilot,"MOVE"] remoteExec ["disableAI",_pilot];
    _fastRopeInfoMap set ["_pilot",_pilot];
    _fastRopeInfoMap set ["_unoccupiedRopeInfoMap",_ropeInfoMaps select 0];
    [_fastRopeInfoMap, true] call KISKA_fnc_fastRope_dropUnits;
    nil
};

/* ----------------------------------------------------------------------------
    Drop Unit
---------------------------------------------------------------------------- */
private _unoccupiedRopeInfoMap = _fastRopeInfoMap get "_unoccupiedRopeInfoMap";
private _unitsToDeploy = _fastRopeInfoMap getOrDefaultCall ["_unitsToDeploy",{[]}];
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
            // for reasons I don't understand, if _hook is not assigned to a variable when checking
            // isNull, the function will silently fail... 
            // cant use `(isNull (_ropeInfoMap getOrDefaultCall ["_hook",{objNull}]))
            private _hook = _ropeInfoMap getOrDefaultCall ["_hook",{objNull}];
            private _unitWasAttachedToRope = _unit getVariable ["KISKA_fastRope_attachedToRope",false];
            // Prevent teleport if hook has been deleted due to rope cut
            if (
                (isNull _hook) OR
                {(_args select 4) getOrDefaultCall ["_queuedEnd", {false}]} OR
                {_unitWasAttachedToRope AND {isNull (attachedTo _unit)}}
            ) exitWith {
                [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;
                [PER_FRAME_HANDLER_ID] call KISKA_fnc_CBA_removePerFrameHandler;
            };

            if !(_unitWasAttachedToRope) exitWith {
                [_ropeInfoMap,_unit] call KISKA_fnc_fastRope_ropeAttachedUnit;
            };

            private _ropeTop = _ropeInfoMap get "_ropeTop";
            private _reachedGround = ((getPosVisual _unit) select 2) < ON_GROUND_BUFFER;
            private _ropeLength = _args select 3;
            private _vehicle = _args select 2;
            if (
                _reachedGround OR
                { (ropeLength _ropeTop) isEqualTo _ropeLength } OR
                { vectorMagnitude (velocity _vehicle) > 5 } OR
                { !((lifeState _unit) in ["HEALTHY", "INJURED"]) }
            ) exitWith {
                [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;

                deleteVehicle [
                    _ropeTop,
                    (_ropeInfoMap get "_ropeBottom")
                ];
                [_ropeInfoMap,_ropeLength] call KISKA_fnc_fastRope_createRope;
                
                [PER_FRAME_HANDLER_ID] call KISKA_fnc_CBA_removePerFrameHandler;
            };
        }, 
        0, 
        [
            _unit, 
            _unoccupiedRopeInfoMap, 
            _vehicle, 
            _fastRopeInfoMap get "_ropeLength", 
            _fastRopeInfoMap
        ]
    ] call KISKA_fnc_CBA_addPerFrameHandler;
    moveOut _unit;
};

/* ----------------------------------------------------------------------------
    Check for recursion end
---------------------------------------------------------------------------- */
_fastRopeInfoMap set ["_unoccupiedRopeInfoMap",nil];
if (_unitsToDeploy isEqualTo []) exitWith {
    [
        {
            if (
                !((_this select 2) call KISKA_fnc_fastRope_isVehicleStillCapable)
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
        private _fastRopeInfoMap = _this select 2;
        if (
            !(_fastRopeInfoMap call KISKA_fnc_fastRope_isVehicleStillCapable)
        ) exitWith { true };
        
        private _continue = false;
        (_this select 1) apply {
            if (
                !(_x getOrDefaultCall ["_isOccupied", {false}]) AND 
                { !(_x getOrDefaultCall ["_isBroken", {false}]) }
            ) then {
                _fastRopeInfoMap set ["_unoccupiedRopeInfoMap",_x];
                _continue = true;
                break;
            };
        };

        _continue
    },
    {
        private _fastRopeInfoMap = _this select 2;
        private _unoccupiedRopeInfoMap = _fastRopeInfoMap get "_unoccupiedRopeInfoMap";
        private _cantProceed = isNil "_unoccupiedRopeInfoMap";
        if (_cantProceed) exitWith {
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
        ] call KISKA_fnc_CBA_waitAndExecute;
    },
    0.25,
    [_vehicle,_ropeInfoMaps,_fastRopeInfoMap]
] call KISKA_fnc_waitUntil;


nil
