/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hover

Description:
    Sends a vehicle to a given point to hover.

    Pilots should ideally be placed in "CARELESS" behaviour when around enemies.

Parameters:
    0: _vehicle <OBJECT> - The helicopter/vtol to hover
    1: _hoverPosition <PositionASL[] or OBJECT> - The positionASL to drop the 
        units off at; Z coordinate matters
    2: _callBackMap <HASHMAP> - A map of callback functions that can be optionally added:
        
        - `_shouldHoverStop`: <CODE> - Code that should return a boolean to determine 
            if the vehicle should stop its hover. This condition is checked every 0.05s.
            
            Parameters:

            - 0: _vehicle - The hover vehicle
            - 1: _pilot - The `currentPilot` of the vehicle

        - `_onHoverEnd`: <CODE, STRING, or ARRAY> - Code that executes after the 
            hover completes, see `KISKA_fnc_callBack`
            
            Parameters:
            
            - 0: _vehicle - The hover vehicle
            - 1: _pilot - The `currentPilot` of the vehicle

        - `_onHoverStart`: <CODE, STRING, or ARRAY> - Code that executes after the 
            vehicle is within 5m of the hover position, see `KISKA_fnc_callBack`
            
            Parameters:
            
            - 0: _vehicle - The hover vehicle
            - 1: _pilot - The `currentPilot` of the vehicle

Returns:
    NOTHING

Examples:
    (begin example)
        [
            myHeli,
            myHoverPositionASL,
            createHashMapFromArray [
                [
                    "_shouldHoverStop", 
                    {
                        localNamespace getVariable ["stopMyHover",false]
                    }
                ],
                [
                    "_onHoverEnd",
                    {
                        hint "after hover";
                    }
                ]
            ]
        ] call KISKA_fnc_hover;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hover";

#define HOVER_INTERVAL 0.05
#define START_VELOCITY_CONTROL_DISTANCE 400
#define DEFAULT_VELOCITY_MAGNITUDE 50
#define MAX_DECELERATION_SPEED 10
#define ACCELERATION_INCREMENT 0.25
#define DISTANCE_TO_DISABLE_PILOT_AI 25
#define DISTANCE_TO_STOP_VELOCITY_ADJUSTMENT 2.5
#define DISTANCE_TO_TRIGGER_ON_HOVER_START 5

private _defaultMap = createHashMap;
params [
    ["_vehicle",objNull,[objNull]],
    ["_hoverPosition",[],[objNull,[]],3],
    ["_callBackMap",_defaultMap,[_defaultMap]]
];


if (isNull _vehicle) exitWith {
    ["_vehicle is null!",true] call KISKA_fnc_log;
    nil
};

private _hoverPositionIsObject = _hoverPosition isEqualType objNull;
if (_hoverPositionIsObject AND { isNull _hoverPosition }) exitWith {
    ["null _hoverPosition passed",true] call KISKA_fnc_log;
    nil
};

if (_hoverPositionIsObject) then {
    _hoverPosition = getPosASL _hoverPosition;
};


private _vehicleGroup = group (commander _vehicle);
_vehicleGroup allowFleeing 0;
private _pilot = driver _vehicle;
_pilot setSkill 1;
_pilot move (ASLToATL _hoverPosition);

private _onHoverStartDefined = "_onHoverStart" in _callBackMap;
// guides helicopter to drop position
[
    {
        params ["_args", "_id"];
        _args params ["_vehicle","_callBackMap"];
        
        private _pilot = currentPilot _vehicle;
        if (
            !(alive _vehicle) OR
            {!(isEngineOn _vehicle)} OR // in case engine dies
            {!(alive _pilot)} OR
            { 
                [_vehicle,_pilot] call (_callBackMap getOrDefaultCall ["_shouldHoverStop",{{false}},true]) 
            }
        ) exitWith {
            if (_pilot getVariable ["KISKA_hover_hoverAiDisabled",true]) then {
                _pilot setVariable ["KISKA_hover_hoverAiDisabled",nil];
                [_pilot,"PATH"] remoteExecCall ["enableAI",_pilot];
            };

            private _onHoverEnd = _callBackMap getOrDefaultCall ["_onHoverEnd",{{}}];
            if (_onHoverEnd isNotEqualTo {}) then {
                [[_vehicle,_pilot],_onHoverEnd] call KISKA_fnc_callBack;
            };

            [_id] call CBA_fnc_removePerFrameHandler;
        };
        
        private _currentVehiclePosition_ASL = getPosASLVisual _vehicle;
        private _hoverPosition = _args select 2;
        private _distanceToHoverPosition = _currentVehiclePosition_ASL vectorDistance _hoverPosition;

        if (_distanceToHoverPosition > START_VELOCITY_CONTROL_DISTANCE) exitWith {};

        if (isNil {_vehicle getVariable "KISKA_hoverTransformStart_speed"}) then {
            _vehicle setVariable ["KISKA_hoverTransformStart_speed",(speed _vehicle) / 3.6];
        };

        private _speed = _vehicle getVariable "KISKA_hoverTransformStart_speed";
        private _velocityMagnitude = DEFAULT_VELOCITY_MAGNITUDE;

        private _withinAccelerationArea = _distanceToHoverPosition > 100;
        if (_withinAccelerationArea) then {
            if (_speed < _velocityMagnitude) then {
                _speed = _speed + ACCELERATION_INCREMENT;
                _vehicle setVariable ["KISKA_hoverTransformStart_speed",_speed];
            };

        } else {
            _speed = (_speed - 1) max MAX_DECELERATION_SPEED;
            _vehicle setVariable ["KISKA_hoverTransformStart_speed",_speed];

        };


        if (
            (_distanceToHoverPosition <= DISTANCE_TO_DISABLE_PILOT_AI) AND
            (_pilot checkAIFeature "PATH")
        ) then {
            [_pilot,"PATH"] remoteExecCall ["disableAI",_pilot];
            _pilot setVariable ["KISKA_hover_hoverAiDisabled",true];
        };

        _velocityMagnitude = _speed;
        if (_distanceToHoverPosition >= DISTANCE_TO_STOP_VELOCITY_ADJUSTMENT) then {
            if ( _distanceToHoverPosition <= 15 ) then {
                _velocityMagnitude = (_distanceToHoverPosition / 10) * 5;
            };

            private _currentVelocity = velocity _vehicle;
            _currentVelocity = (_currentVehiclePosition_ASL vectorFromTo _hoverPosition) vectorMultiply _velocityMagnitude;
            _vehicle setVelocity _currentVelocity;
        };

        private _onHoverStartDefined = _args select 3;
        if (
            _onHoverStartDefined AND 
            {_distanceToHoverPosition <= DISTANCE_TO_TRIGGER_ON_HOVER_START} AND 
            {
                !(_vehicle getVariable ["KISKA_hover_onHoverStartTriggered",false])
            }
        ) then {
            _vehicle setVariable ["KISKA_hover_onHoverStartTriggered",true];
            private _onHoverStart = _callBackMap get "_onHoverStart";
            [[_vehicle,_pilot],_onHoverStart] call KISKA_fnc_callBack;
        };

    },
    HOVER_INTERVAL,
    [
        _vehicle,
        _callBackMap,
        _hoverPosition,
        _onHoverStartDefined
    ]
] call CBA_fnc_addPerFrameHandler;


nil
