/* ----------------------------------------------------------------------------
Function: KISKA_fnc_slingLoad

Description:
    Tells AI helicopter to pick up a given object and drop it off at a given location.

Parameters:
    0: _heli : <OBJECT> - Helicopter with pilot to perform slingload
    1: _liftObject : <OBJECT> - The object to sling load
    2: _dropOffPoint : <ARRAY, OBJECT, LOCATION, or GROUP> - Where to drop the _liftObject off at
    3: _afterDropCode : <ARRAY, CODE, or STRING> - Code to execute after the drop off waypoint is complete.
        This is saved to the pilot's namespace in "KISKA_postSlingLoadCode" which is deleted after
        it is called. (See KISKA_fnc_callBack)
            
        Parmeters:
        - 0. <OBJECT> - The pilot of the helicopter
        - 1. <OBJECT> - The helicopter
                
    4: _flightPath : <(PositionASL | OBJECT | LOCATION | GROUP)[]> - An array of sequential positions
        the aircraft must travel prior to droping off the _liftObject

Returns:
    <ARRAY> -
        0: <OBJECT> - The pilot
        1: <GROUP> - Pilot's group
        2: <ARRAY> - Generated waypoints

Examples:
    (begin example)
        [
            heli,
            someObject,
            dropOff,
            [
                [heli],
                {
                    hint str [_this,_thisArgs]
                }
            ]
        ] call KISKA_fnc_slingLoad;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_slingLoad";

// TODO: this may need to be a gradient
#define LIMIT_SPEED_DISTANCE 200
#define DISTANCE_STEP_SIZE 50
#define SPEED_STEP_SIZE 5

params [
    ["_heli",objNull,[objNull]],
    ["_liftObject",objNull,[objNull]],
    ["_dropOffPoint",objNull,[[],objNull,grpNull,locationNull]],
    ["_afterDropCode",{},[[],{},""]],
    ["_flightPath",[],[[]]]
];

/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if !(alive _heli) exitWith {
    ["_heli is not alive! Exiting...", true] call KISKA_fnc_log;
    []
};

private _pilot = currentPilot _heli;
if !(alive _pilot) exitWith {
    [[_heli,"'s pilot is not alive! Exiting..."], true] call KISKA_fnc_log;
    []
};

if !(alive _liftObject) exitWith {
    ["_liftObject is dead, will not lift..."] call KISKA_fnc_log;
    []
};

if !(_heli canSlingLoad _liftObject) exitWith {
    [[_heli," can't lift ",_liftObject], true] call KISKA_fnc_log;
    []
};

private _dropOffPointIsInvalid = (
    (_dropOffPoint isEqualTypeAny [grpNull,locationNull,objNull] AND
    {isNull _dropOffPoint}) OR
    (_dropOffPoint isEqualTo [])
);

if (_dropOffPointIsInvalid) exitWith {
    ["Invalid _dropOffPoint provided",true] call KISKA_fnc_log;
    []
};


/* ----------------------------------------------------------------------------
    Add waypoints
---------------------------------------------------------------------------- */
private _group = group _pilot;
[_group] call KISKA_fnc_clearWaypoints;


/* -------------------------------------
    Handle Speed
------------------------------------- */
private _distanceToCargo2d = _heli distance2D _liftObject;
private _limitSpeedId = -1;
if (_distanceToCargo2d <= LIMIT_SPEED_DISTANCE) then {

    if !(["KISKA_limitSpeed"] call KISKA_fnc_managedRun_isDefined) then {
        [
            "KISKA_limitSpeed",
            {
                params [
                    ["_vehicle",objNull,[objNull]],
                    ["_speed",-1,[123]]
                ];
                _vehicle limitSpeed _speed;
            }
        ] call KISKA_fnc_managedRun_updateCode;
    };

    private _speedLimit = ((_distanceToCargo2d / DISTANCE_STEP_SIZE) * SPEED_STEP_SIZE) min SPEED_STEP_SIZE;
    _limitSpeedId = [
        "KISKA_limitSpeed",
        [_heli,_speedLimit],
        _heli
    ] call KISKA_fnc_managedRun_execute;
};

/* -------------------------------------
    Hook cargo
------------------------------------- */
[
    _group,
    _liftObject,
    "HOOK",
    createHashMapFromArray [
        ["randomRadius",-1],
        ["behaviour","SAFE"],
        ["combatMode","BLUE"],
        [
            "onComplete", 
            [[_heli,_limitSpeedId], {
                _thisArgs params ["_heli","_limitSpeedId"];
                if (_limitSpeedId >= 0) then {
                    [
                        "KISKA_limitSpeed",
                        // BOHEMIA BUG: wiki states that -1 will remove a speed limit, 
                        // however, at least for helicopters, that does not seem to be the case
                        [_heli,999999],
                        _heli,
                        _limitSpeedId
                    ] call KISKA_fnc_managedRun_execute;
                };
            }]
        ]
    ]
] call KISKA_fnc_addWaypoint;


/* -------------------------------------
    Drop off
------------------------------------- */
if (_flightPath isNotEqualTo []) then {
    _flightPath apply {
        [
            _group,
            _x,
            "MOVE",
            createHashMapFromArray [
                ["randomRadius",-1]
            ]
        ] call KISKA_fnc_addWaypoint;
    };
};

[
    _group,
    _dropOffPoint,
    "UNHOOK",
    createHashMapFromArray [
        ["randomRadius",-1],
        [
            "onComplete", 
            [[_heli,_pilot,_afterDropCode],{
                _thisArgs params ["_heli","_pilot","_afterDropCode"];
                [[_pilot,_heli],_afterDropCode] call KISKA_fnc_callBack; 

            }]
        ]
    ]
] call KISKA_fnc_addWaypoint;


[_pilot, _group, waypoints _group];
