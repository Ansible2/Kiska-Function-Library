/* ----------------------------------------------------------------------------
Function: KISKA_fnc_heliLand

Description:
    Makes a helicopter land at a given position.

Parameters:
    0: _aircraft <OBJECT> - The helicopter
    1: _landingPosition <PositionASL[] or OBJECT> - Where to land. If object, position ATL is used.
    2: _landMode <STRING> - Options are `"LAND"`, `"GET IN"`, and `"GET OUT"`
    3: _landingDirection <NUMBER> - The direction the vehicle should face when landed.
        `-1` means that there shouldn't be any change to the direction. Be aware that this 
        will have to `setDir` of the helipad.
    4: _afterLandCode <CODE, STRING, or ARRAY> - Code to `spawn` after the helicopter has landed. See `KISKA_fnc_callBack`.
        
        Parameters:
        - 0: <OBJECT> - The helicopter
        

Returns:
    <BOOL> - True if helicopter can attempt, false if problem

Examples:
    (begin example)
        [myHeli,position player] call KISKA_fnc_heliLand;
    (end)

Author:
    Karel Moricky,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_heliLand";

#define INVISIBLE_PAD_TYPE "Land_HelipadEmpty_F"
#define LAND_EVENT "KISKA_landedEvent"
#define HIGH_LANDED_THRESHOLD 3
#define ALTITUDE_COMPARE_LOG_COUNT 10
#define VELOCITY_THRESHOLD 5

params [
    ["_aircraft",objNull,[objNull]],
    ["_landingPosition",[],[[],objNull]],
    ["_landMode","LAND",[""]],
    ["_landingDirection",-1,[123]],
    ["_afterLandCode",{},[{},"",[]]]
];

if (isNull _aircraft) exitWith {
    ["_aircraft is a null object",true] call KISKA_fnc_log;
    nil
};

if (!(_aircraft isKindOf "Helicopter") AND {!(_aircraft isKindOf "VTOL_Base_F")}) exitWith {
    [[_aircraft," is not a helicopter or VTOL, exiting..."],true] call KISKA_fnc_log;
    nil
};

[group (currentPilot _aircraft),true] call KISKA_fnc_ACEX_setHCTransfer;

// move command only supports positions, not objects
if (_landingPosition isEqualType objNull) then {
    if (_landingDirection isEqualTo -1) then {
        _landingDirection = getDir _landingPosition;
    };
    _landingPosition = getPosASL _landingPosition;
};

// Using a helipad to support the ability to have a landing direction
// Helicopters will attempt to land in the direction the helipad is facing
private _helipadToLandAt = INVISIBLE_PAD_TYPE createVehicle _landingPosition;
_helipadToLandAt setPosASL _landingPosition;
if (_landingDirection isNotEqualTo -1) then {
    _helipadToLandAt setDir _landingDirection;
};

private _keepEngineOn = false;
private _consideredLandedHeightOffset = 0.1;
_landMode = toUpperANSI _landMode;
if (_landMode isNotEqualTo "LAND") then {
    switch (_landMode) do {
        case "GETIN";
        case "GETOUT";
        case "GET IN";
        case "GET OUT": {
            _keepEngineOn = true;
            _consideredLandedHeightOffset = HIGH_LANDED_THRESHOLD;
        };

        default {
            [["Unknown land type: ", _landMode," used for aircraft: ",_aircraft," . Changing to mode 'LAND'"],true] call KISKA_fnc_log;
            _landMode = "LAND";
        };
    };
};


[
    _aircraft,
    _landingPosition,
    _landMode,
    _afterLandCode,
    _keepEngineOn,
    _consideredLandedHeightOffset,
    _helipadToLandAt
] spawn {
    params [
        "_aircraft",
        "_landingPosition",
        "_landMode",
        "_afterLandCode",
        "_keepEngineOn",
        "_consideredLandedHeightOffset",
        "_helipadToLandAt"
    ];

    [_aircraft,_landingPosition] remoteExecCall ["move",_aircraft];
    _aircraft setVariable ["KISKA_isLanding",true];

    private _aircraftPositionLogs = [];
    private _isWavingOff = {
        import ["_aircraft","_landingPosition"];
        private _currentLandStatus = landAt _aircraft;
        private _currentLandResult = _currentLandStatus select 1;
        if (_currentLandResult != "Found") exitWith { true };

        private _currentLandingPosition = _currentLandStatus select 2;
        (_currentLandingPosition vectorDistance _landingPosition) > 20
    };

    private _helipadPosition = getPosASL _helipadToLandAt;
    private _helipadAltitude = _helipadPosition select 2;
    private _wasToldToLand = false;

    waitUntil {
        sleep 1;

        if (
            !(alive _aircraft) OR 
            (_aircraft getVariable ["KISKA_cancelLanding",false])
        ) then { breakWith true };

        if !(_wasToldToLand) exitWith {
            if (unitReady _aircraft) then {
                hint "was told to land";
                [_aircraft,[_helipadToLandAt,_landMode]] remoteExecCall ["landAt",_aircraft];
                _wasToldToLand = true;
            };
            false
        };

        private _aircraftPosition = getPosASL _aircraft;
        private _currentAircraftAltitude = _aircraftPosition select 2;
        if (
            (isTouchingGround _aircraft) OR 
            (_currentAircraftAltitude <= (_consideredLandedHeightOffset + _helipadAltitude))
        ) then {
            hint "touchdown";

            // reinforce land
            // sometimes, the helicopter will "land" but immediately take off again
            // this is why the thing is told to land again
            sleep 2;
            [_aircraft,[_helipadToLandAt,_landMode]] remoteExecCall ["landAt",_aircraft];

            if (_keepEngineOn) then {
                [_aircraft,true] remoteExecCall ["engineOn",_aircraft];
            };

            breakWith true;
        };

        if (call _isWavingOff) exitWith {
            hint "is waving off";
            _wasToldToLand = false;
            sleep 2;
            _aircraft land "NONE";
            hint "cancelled landing";
            
            false
        };

        false
    };

    // variable to track if other code can run
    _aircraft setVariable ["KISKA_cancelLanding",false];
    _aircraft setVariable ["KISKA_isLanding",false];

    [[_aircraft],_afterLandCode] call KISKA_fnc_callBack;
    [_aircraft,LAND_EVENT,[_aircraft]] call BIS_fnc_callScriptedEventHandler;

    deleteVehicle _helipadToLandAt;
};


nil
