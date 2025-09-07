/* ----------------------------------------------------------------------------
Function: KISKA_fnc_closeAirSupport

Description:
    A more detailed version of KISKA_fnc_CAS that allows the caller to specify
     a number of parameters.

Parameters:
    0: _aircraftParams : <HASHMAP> - A hashmap of various parameters that affect
        ther aircraft.

        - `aircraftClass`: <STRING> Default: `""` - the class of aircraft to spawn.
        - `side`: <SIDE> Default: `BLUFOR` - The side of the aircraft to spawn.
        - `allowDamage`: <BOOLEAN> Default: `false` - Whether or not the aircraft and crew take damage.
        - `attackPosition`: <PositionASL[] | OBJECT> Default: `objNull` - The primary position to fire at.
        - `directionOfAttack`: <NUMBER> Default: `0` - The direction the aircraft will be facing during it's attack run.
        - `fireDistance`: <NUMBER> Default: `initialDistanceToTarget` - The distance to the
            target at which the aircraft will begin firing.
        - `initialHeightAboveTarget`: <NUMBER> Default: `1300` - The aircraft's initial altitude.
        - `initialDistanceToTarget`: <NUMBER> Default: `2000` - The distance from the `_attackPosition` the aircraft will spawn.
        - `breakOffDistance`: <NUMBER> Default: `500` - The three dimensional distance between the `_attackPosition` 
            and the aircraft at which point it will abandon it's firing orders and egress.
        - `numberOfFlaresToDump`: <NUMBER> Default: `4` - The number of flares to fire off after breaking off.
        - `approachSpeed`: <NUMBER> Default: `75` - How many meters per second will the 
            aircraft be flying while approaching the `_attackPosition`.
        - `vectorToTargetOffset`: <NUMBER[]> Default: `[0,0,0]` - Used with `vectorAdd` on the aircraft's
            starting position to get the vector it will follow to engage the target.
            This can be used if an aircraft seems to be firing off target.

    1: _fireOrders : <[STRING,STRING,NUMBER,NUMBER,STRING,NUMBER][]> - An array of firing orders
        that determine how an aircraft will fire at the target.
        See `KISKA_fnc_closeAirSupport_parseFireOrders` for more detail. 

Returns:
    NOTHING

Examples:
    (begin example)
        // fire gun
        [
            createHashMapFromArray [
                ["aircraftClass","B_Plane_CAS_01_dynamicLoadout_F"],
                ["numberOfFlaresToDump",4],
                ["attackPosition",theTarget]
            ],
            [
                [
                    "Gatling_30mm_Plane_CAS_01_F",
                    "",
                    50,
                    0.05,
                    "",
                    0.1
                ]
            ]
        ] call KISKA_fnc_closeAirSupport;
    (end)

    (begin example)
        // drop napalm
        [
            createHashMapFromArray [
                ["aircraftClass","B_Plane_CAS_01_dynamicLoadout_F"],
                ["numberOfFlaresToDump",0],
                ["attackPosition",theTarget]
            ],
            [
                [
                    "pylon",
                    "vn_bomb_f4_out_500_blu1b_fb_mag_x4",
                    4,
                    0.5,
                    "guide_to_strafe_target",
                    1
                ]
            ]
        ] call KISKA_fnc_closeAirSupport;
    (end)

    (begin example)
        // shoot gun and fire rockets
        [
            createHashMapFromArray [
                ["aircraftClass","B_Plane_CAS_01_dynamicLoadout_F"],
                ["numberOfFlaresToDump",0],
                ["attackPosition",theTarget]
            ],
            [
                [
                    "Gatling_30mm_Plane_CAS_01_F",
                    "",
                    50,
                    0.05,
                    "",
                    0
                ],
                [
                    "pylon",
                    "PylonRack_7Rnd_Rocket_04_HE_F",
                    7,
                    0.5,
                    "guide_to_strafe_target",
                    0.01
                ]
            ]
        ] call KISKA_fnc_closeAirSupport;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_closeAirSupport";

#define TIME_TILL_DELETE 65
#define FLARE_LAUNCHER_CLASS "CMFlareLauncher"
#define TARGET_CLASS_NAME "Sign_Sphere200cm_F"
#define BOUNDING_BOX_TYPE "ViewGeometry"
#define DEFAULT_FIRE_DISTANCE -1

params [
    ["_aircraftParams",[],[createHashMap]],
    ["_fireOrders",[],[[]]]
];

if (_fireOrders isEqualTo []) exitWith {
    ["_fireOrders list is empty!",true] call KISKA_fnc_log;
    nil
};

private _paramDetails = [
    ["aircraftClass",{""},[""]],
    ["side",{BLUFOR},[sideUnknown]],
    ["allowDamage",{false},[true]],
    ["attackPosition",{objNull},[[],objNull]],
    ["directionOfAttack",{0},[123]],
    ["initialHeightAboveTarget",{1300},[123]],
    ["initialDistanceToTarget",{2000},[123]],
    ["breakOffDistance",{500},[123]],
    ["numberOfFlaresToDump",{4},[123]],
    ["approachSpeed",{75},[123]],
    ["vectorToTargetOffset",{[0,0,0]},[[]]],
    ["fireDistance",{DEFAULT_FIRE_DISTANCE},[123]]
];
private _paramValidationResult = [_aircraftParams,_paramDetails] call KISKA_fnc_hashMapParams;
if (_paramValidationResult isEqualType "") exitWith {
    [_paramValidationResult,true] call KISKA_fnc_log;
    nil
};
(_paramValidationResult select 0) params (_paramValidationResult select 1);

if (_fireDistance isEqualTo DEFAULT_FIRE_DISTANCE) then {
    _fireDistance = _initialDistanceToTarget;
};

/* ----------------------------------------------------------------------------
    Position plane towards target
---------------------------------------------------------------------------- */
private _attackPositionIsObject = _attackPosition isEqualType objNull;
if (
    (_attackPositionIsObject) AND 
    {isNull _attackPosition} OR 
    {_attackPosition isEqualTo []}
) exitWith {
    [[_attackPosition," is an invalid target"],true] call KISKA_fnc_log;
    nil
};

private _aircraftCfg = configfile >> "cfgvehicles" >> _aircraftClass;
if !(isclass _aircraftCfg) exitwith {
    [["_aircraftClass -> ", _aircraftClass," was not found..."],true] call KISKA_fnc_log;
    nil
};

if (_attackPositionIsObject) then {
    _attackPosition = getPosASL _attackPosition;
};
if ((_attackPosition select 2) < 0) then {
    _attackPosition set [2,0];
};

private _spawnPosition = [
    _attackPosition,
    _initialDistanceToTarget,
    _directionOfAttack + 180,
    _initialHeightAboveTarget
] call KISKA_fnc_getPosRelativeASL;
private _aircraftSpawnInfo = [
    _spawnPosition,
    _directionOfAttack,
    _aircraftClass,
    _side
] call KISKA_fnc_spawnVehicle;

_aircraftSpawnInfo params ["_aircraft","_crew","_aircraftGroup"];

[_aircraftGroup,true] call KISKA_fnc_ACEX_setHCTransfer;
if !(_allowDamage) then {
    _aircraft allowDamage false;
    _crew apply {
        _x allowDamage false;
    };
};
_aircraft setPosWorld _spawnPosition;
private _initialPositionWorld = [_aircraft,BOUNDING_BOX_TYPE] call KISKA_fnc_getBoundingBoxCenter;
_aircraft setDir _directionOfAttack;
_aircraft disableAi "autotarget";
_aircraft setCombatMode "blue";


/* ----------------------------------------------------------------------------
    Check fire orders
---------------------------------------------------------------------------- */
private _fireOrdersParsed = [
    _aircraft,
    _fireOrders
] call KISKA_fnc_closeAirSupport_parseFireOrders;

private _fireOrdersAreInvalid = _fireOrdersParsed isEqualTo [];
if (_fireOrdersAreInvalid) exitWith {
    deleteVehicleCrew _aircraft;
    _crew apply {
        if (alive _x) then { deleteVehicle _x };
    };

    if (alive _aircraft) then { deleteVehicle _aircraft; };
    if (!isNull _aircraftGroup) then { deleteGroup _aircraftGroup; };
    nil
};


/* ----------------------------------------------------------------------------
    Fix planes velocity towards the target
---------------------------------------------------------------------------- */
private _vectors = [_initialPositionWorld vectorAdd _vectorToTargetOffset,_attackPosition] call KISKA_fnc_getVectorToTarget;
_aircraft setVectorDirAndUp _vectors;
_vectors params ["_aircraftVectorDirTo","_aircraftVectorUp"];
private _vectorDistanceToTarget = _attackPosition vectorDistance _initialPositionWorld;
private _flightTime = (_vectorDistanceToTarget - _breakOffDistance) / _approachSpeed;
private _startTime = time;
private _timeAfterFlight = _startTime + _flightTime;

[
    "KISKA_closeAirSupport_originalTarget",
    "KISKA_closeAirSupport_strafeTarget"
] apply {
    private _target = createVehicleLocal [
        TARGET_CLASS_NAME,
        [0,0,0],
        [],
        0,
        "NONE"
    ];
    hideObject _target;
    _target setPosASL _attackPosition;
    _aircraft setVariable [_x,_target];
};

_aircraft addEventHandler ["killed",{
    params ["_aircraft"];
    [
        "KISKA_closeAirSupport_originalTarget",
        "KISKA_closeAirSupport_strafeTarget"
    ] apply {
        private _target = _aircraft getVariable [_x,objNull];
        if !(isNull _target) then { deleteVehicle _target };
    };
}];

[
    {
        params ["_args","_id"];
        _args params [
            "_aircraft",
            "_attackTarget",
            "_strafeTarget",
            "_directionOfAttack",
            "_breakOffDistance",
            "_initialPositionWorld",
            "_startTime",
            "_timeAfterFlight",
            "_aircraftSpawnInfo",
            "_aircraftVectorDirTo",
            "_aircraftVectorUp",
            "_side",
            "_initialDistanceToTarget",
            "_initialHeightAboveTarget",
            "_approachSpeed",
            "_numberOfFlaresToDump",
            "_fireOrders",
            "_fireDistance"
        ];

        private _updatedAttackPosition = getPosASLVisual _strafeTarget;
        private _aircraftPositionWorld = [_aircraft,BOUNDING_BOX_TYPE] call KISKA_fnc_getBoundingBoxCenter;
        private _vectorDistanceToTarget = _updatedAttackPosition vectorDistance _aircraftPositionWorld;

        /* ----------------------------------------------------------------------------
            Handle After CAS complete
        ---------------------------------------------------------------------------- */
        private _casIsComplete = isNull _aircraft OR
            {_aircraft getVariable ["KISKA_closeAirSupport_complete",false]} OR
            {_vectorDistanceToTarget <= _breakOffDistance};
        if (_casIsComplete) exitWith {
            _aircraft setVariable ["KISKA_closeAirSupport_complete",true];

            private _positionPastTarget = _updatedAttackPosition getPos [5000,_directionOfAttack];
            _aircraft move _positionPastTarget;
            _aircraft flyInHeight (_initialHeightAboveTarget * 2);

            private _pilot = currentPilot _aircraft;
            for "_i" from 1 to _numberOfFlaresToDump do {
                [
                    {
                        params ["_pilot"];
                        _pilot forceweaponfire [FLARE_LAUNCHER_CLASS,"Burst"];
                    },
                    [_pilot],
                    _i
                ] call CBA_fnc_waitAndExecute;
            };
            
            // give the aircraft some time to get out of audible distance before deletion
            [
                {
                    params ["_aircraft","_crew","_group"];
                    [
                        "KISKA_closeAirSupport_originalTarget",
                        "KISKA_closeAirSupport_strafeTarget"
                    ] apply {
                        private _target = _aircraft getVariable [_x,objNull];
                        if !(isNull _target) then { deleteVehicle _target };
                    };

                    _crew apply {
                        if !(isNull _x) then {
                            _aircraft deleteVehicleCrew _x;
                        };
                    };

                    if (alive _aircraft) then { deleteVehicle _aircraft; };
                    if !(isNull _group) then { deleteGroup _group; };
                },
                _aircraftSpawnInfo,
                TIME_TILL_DELETE
            ] call CBA_fnc_waitAndExecute;

            [_id] call KISKA_fnc_CBA_removePerFrameHandler;
        };

        //--- Set the plane approach vector
        private _interval = linearConversion [_startTime,_timeAfterFlight,time,0,1];
        private _velocity = (vectorNormalized (_updatedAttackPosition vectorDiff _aircraftPositionWorld)) vectorMultiply _approachSpeed;
        _aircraft setVelocityTransformation [
            _initialPositionWorld, _updatedAttackPosition,
            _velocity, _velocity,
            _aircraftVectorDirTo, _aircraftVectorDirTo,
            _aircraftVectorUp, _aircraftVectorUp,
            _interval
        ];

        // if not within range
        if (_vectorDistanceToTarget > _fireDistance) exitWith {};

        if !(_aircraft getVariable ["KISKA_closeAirSupport_isFiring",false]) then {
            private _laserTarget = laserTarget _attackTarget;
            _aircraft reveal _laserTarget;
            _aircraft dowatch _laserTarget;
            _aircraft dotarget _laserTarget;

  
            [
                _aircraft,
                _attackTarget,
                _strafeTarget,
                _fireOrders
            ] call KISKA_fnc_closeAirSupport_fire;
        } else {
            private _strafeIncrement = _aircraft getVariable ["KISKA_closeAirSupport_strafeIncrement",0.1];
            private _nextAttackPostition = AGLToASL (_strafeTarget getPos [_strafeIncrement,_directionOfAttack]);
            if ((_nextAttackPostition select 2) < 0) then {
                _nextAttackPostition set [2,0];
            };
            _strafeTarget setPosASL _nextAttackPostition;
        };

    },
    0.01,
    [
        _aircraft,
        _aircraft getVariable "KISKA_closeAirSupport_originalTarget",
        _aircraft getVariable "KISKA_closeAirSupport_strafeTarget",
        _directionOfAttack,
        _breakOffDistance,
        _initialPositionWorld,
        _startTime,
        _timeAfterFlight,
        _aircraftSpawnInfo,
        _aircraftVectorDirTo,
        _aircraftVectorUp,
        _side,
        _initialDistanceToTarget,
        _initialHeightAboveTarget,
        _approachSpeed,
        _numberOfFlaresToDump,
        _fireOrdersParsed,
        _fireDistance
    ]
] call CBA_fnc_addPerframeHandler;


nil
