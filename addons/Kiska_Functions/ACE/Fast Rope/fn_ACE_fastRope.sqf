/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_fastRope

Description:
    Sends a vehicle to a given point and fastropes the given units from the helicopter.

    Pilots should ideally be placed in "CARELESS" behaviour when around enemies.
    
Parameters:
	0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _dropPosition <ARRAY> - The positionASL to drop the units off at; Z coordinate
        matters
    2: _unitsToDeploy <ARRAY> - An array of units to drop from the _vehicle.
    3: _afterDropCode <CODE or STRING or ARRAY> - Code to execute after the drop is complete, see KISKA_fnc_callBack
            Parameters:
                0: _vehicle - The drop vehicle

    4: _hoverHeight <NUMBER> - The height the helicopter should hover above the drop position
        while units are fastroping. Max is 28, min is 5

Returns:
	NOTHING

Examples:
    (begin example)
		[
            _vehicle,
            [0,0,0],
            (fullCrew [_vehicle,"cargo"]) apply {
                _x select 0
            }
		] call KISKA_fnc_ACE_fastRope;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_fastRope";

#define MIN_HOVER_HEIGHT 5
#define MAX_HOVER_HEIGHT 28

if !(["ace_fastroping"] call KISKA_fnc_isPatchLoaded) exitWith {
    ["ace_fastroping is required for this function",true] call KISKA_fnc_log;
    nil
};

params [
    ["_vehicle",objNull,[objNull]],
    ["_dropPosition",[],[[],objNull]],
    ["_unitsToDeploy",[],[[],grpNull,objNull]],
    ["_afterDropCode",{},["",{},[]]],
    ["_hoverHeight",20,[123]]
];


/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if (isNull _vehicle) exitWith {
    ["_vehicle is null!",true] call KISKA_fnc_log;
    nil
};

[_vehicle] call ace_fastroping_fnc_equipFRIES;
if !([_vehicle] call ace_fastroping_fnc_canPrepareFRIES) exitWith {
    [[typeOf _vehicle," is not configured for ACE FRIES system! or this vehicle can't fastrope"],true] call KISKA_fnc_log;

};

if (_dropPosition isEqualType objNull) then {
    _dropPosition = getPosASL _dropPosition;
};

_hoverHeight = _hoverHeight max MIN_HOVER_HEIGHT;
_hoverHeight = _hoverHeight min MAX_HOVER_HEIGHT;

if (_afterDropCode isEqualType "") then {
    _afterDropCode = compile _afterDropCode;
};


/* ----------------------------------------------------------------------------
    Verify _unitsToDeploy
---------------------------------------------------------------------------- */
if (_unitsToDeploy isEqualTo []) exitWith {
    ["_unitsToDeploy is empty",true] call KISKA_fnc_log;
    false
};

if (_unitsToDeploy isEqualTypeAny [objNull,grpNull] AND {isNull _unitsToDeploy}) exitWith {
    ["_unitsToDeploy isNull",true] call KISKA_fnc_log;
    false
};

if (_unitsToDeploy isEqualType grpNull) then {
    _unitsToDeploy = units _unitsToDeploy;
};

if (_unitsToDeploy isEqualType objNull) then {
    _unitsToDeploy = [_unitsToDeploy];
};

private _unitsToDeployFiltered = [];
if (_unitsToDeploy isEqualType []) then {
    _unitsToDeploy apply {
        if (_x isEqualType grpNull) then {
            _unitsToDeployFiltered append (units _x);
        };

        if (_x isEqualType objNull) then {
            _unitsToDeployFiltered pushBackUnique _x;
        };
    };
};

if (_unitsToDeployFiltered isEqualTo []) then {
    _unitsToDeployFiltered = _unitsToDeploy;
};


/* ----------------------------------------------------------------------------
    Prepare FRIES
---------------------------------------------------------------------------- */
_vehicle setVariable ["ACE_Rappelling",true];
private _hoverPosition_ASL = _dropPosition vectorAdd [0,0,_hoverHeight];
private _pilot = driver _vehicle;

private _vehicleGroup = group (commander _vehicle);
_vehicleGroup allowFleeing 0;

private _pilot = driver _vehicle;
_pilot setSkill 1;
_pilot move (ASLToATL _hoverPosition_ASL);

// guides helicopter to drop position
[
    {
        params ["_args", "_id"];
        _args params [
            "_vehicle",
            "_hoverPosition_ASL",
            "_pilot"
        ];

        if (
            alive _vehicle AND
            alive _pilot AND
            !isNil {_vehicle getVariable "ACE_Rappelling"}
        ) then {
            private _currentVehiclePosition_ASL = getPosASL _vehicle;
            private _distanceToHoverPosition = _currentVehiclePosition_ASL vectorDistance _hoverPosition_ASL;

            if ( _distanceToHoverPosition <= 400 ) then {
                if (isNil {_vehicle getVariable "KISKA_fastRopeTransformStart_speed"}) then {
                    _vehicle setVariable ["KISKA_fastRopeTransformStart_speed",(speed _vehicle) / 3.6];
                };

                private _speed = _vehicle getVariable "KISKA_fastRopeTransformStart_speed";
                private _velocityMagnitude = 50;
                if (_speed < _velocityMagnitude AND (_distanceToHoverPosition > 100)) then {
                    _speed = _speed + 0.25;
                    _vehicle setVariable ["KISKA_fastRopeTransformStart_speed",_speed];

                } else {
                    if (_distanceToHoverPosition <= 100) then {
                        _speed = (_speed - 1) max 10;
                        _vehicle setVariable ["KISKA_fastRopeTransformStart_speed",_speed];
                    };
                };

                _velocityMagnitude = _speed;

                if ((_currentVehiclePosition_ASL distance2d _hoverPosition_ASL) < 2.5) then {
                    _vehicle setVelocityModelSpace [0,0,0];

                } else {
                    if ( _distanceToHoverPosition <= 15 ) then {
                        _velocityMagnitude = (_distanceToHoverPosition / 10) * 5;

                    };

                    private _currentVelocity = velocity _vehicle;
                    _currentVelocity = (_currentVehiclePosition_ASL vectorFromTo _hoverPosition_ASL) vectorMultiply _velocityMagnitude;
                    _vehicle setVelocity _currentVelocity;

                };

            };

        } else {
            [_id] call CBA_fnc_removePerFrameHandler;

        };
    },
    0.05,
    [_vehicle, _hoverPosition_ASL, _pilot]
] call CBA_fnc_addPerFrameHandler;


/* ----------------------------------------------------------------------------
    Monitor drop for completion
---------------------------------------------------------------------------- */
[
    {
        params ["_vehicle","_hoverPosition_ASL","_pilot","",""];
        if (!alive _vehicle) exitWith {true};
        if (!alive _pilot) exitWith {true};
        private _currentVehiclePosition_ASL = getPosASL _vehicle;

        (speed _vehicle < (2.5 * 3.6))
        AND
        {
            (_hoverPosition_ASL distance2d _currentVehiclePosition_ASL) < 25
        }
        AND
        {
            (_hoverPosition_ASL vectorDiff _currentVehiclePosition_ASL) select 2 < 25
        }
    },
    {
        params ["_vehicle","","_pilot","_unitsToDeploy","_afterDropCode"];

        if (alive _vehicle AND (alive _pilot)) then {
            [_vehicle, _unitsToDeploy] call KISKA_fnc_ACE_deployFastRope;

            [_vehicle,_afterDropCode] spawn {
                params ["_vehicle","_afterDropCode"];

                waitUntil {
                    sleep 1;
                    ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isNotEqualTo [])
                };

                waitUntil {
                    sleep 1;
                    ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isEqualTo [])
                };

                _vehicle setVariable ["ACE_Rappelling",nil];

                [
                    [_vehicle],
                    _afterDropCode
                ] call KISKA_fnc_callBack;

            };
        };

    },
    [_vehicle,_hoverPosition_ASL,_pilot,_unitsToDeployFiltered,_afterDropCode]
] call CBA_fnc_waitUntilAndExecute;
