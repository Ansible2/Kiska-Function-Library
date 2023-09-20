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

#define LIMIT_SPEED_DISTANCE 200
#define SPEED_LIMIT 20

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

private _limitSpeed = (_heli distance2D _liftObject) < LIMIT_SPEED_DISTANCE;
if (_limitSpeed) then {
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

    private _limitSpeedId = [
        "KISKA_limitSpeed",
        [_heli,SPEED_LIMIT],
        _heli
    ] call KISKA_fnc_managedRun_execute;

    _pilot setVariable ["KISKA_slingLoad_limitSpeedId",_limitSpeedId];
};

[
    _group,
    _liftObject,
    -1,
    "HOOK",
    "SAFE",
    "BLUE"
] call CBA_fnc_addWaypoint;


if (_flightPath isNotEqualTo []) then {
    _flightPath apply {
        [
            _group,
            _x,
            -1,
            "MOVE"
        ] call CBA_fnc_addWaypoint;
    };
};

_pilot setVariable ["KISKA_postSlingLoadCode",_afterDropCode];
_pilot setVariable ["KISKA_onUnhook",{
    params ["_pilot"];

    private _heli = objectParent _pilot;
    private _limitSpeedId = _pilot getVariable ["KISKA_slingLoad_limitSpeedId",-1];
    if (_limitSpeedId > -1) then {
        private _limitSpeedId = [
            "KISKA_limitSpeed",
            [_heli,-1],
            _heli,
            _limitSpeedId
        ] call KISKA_fnc_managedRun_execute;

        _pilot setVariable ["KISKA_slingLoad_limitSpeedId",nil];
    };

    private _afterDropCode = _pilot getVariable ['KISKA_postSlingLoadCode',{}]; 
    [[_pilot,_heli],_afterDropCode] call KISKA_fnc_callBack; 

    _pilot setVariable ['KISKA_postSlingLoadCode',nil];
}];

[
    _group,
    _dropOffPoint,
    -1,
    "UNHOOK",
    "UNCHANGED",
    "NO CHANGE",
    "UNCHANGED",
    "NO CHANGE",
    "[this] call (this getVariable ['KISKA_onUnhook',{}]); this setVariable ['KISKA_onUnhook',nil];"
] call CBA_fnc_addWaypoint;


[_pilot, _group, waypoints _group];
