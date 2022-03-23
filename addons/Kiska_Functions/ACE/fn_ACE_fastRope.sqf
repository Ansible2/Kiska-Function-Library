/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_fastRope

Description:
    Sends a vehicle to a given point and fastropes the given units from the helicopter.

Parameters:
	0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _dropPosition <ARRAY> - The positionASL to drop the units off at; Z coordinate
        matters
    2: _unitsToDeploy <ARRAY> - An array of units to drop from the _vehicle.
    3: _afterDropCode <CODE or STRING> - Code to execute after the drop is complete
            (code is run in unscheduled)
            Parameters:
                0: _vehicle - The drop vehicle

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

params [
    ["_vehicle",objNull,[objNull]],
    ["_dropPosition",[],[[],objNull]],
    ["_unitsToDeploy",[],[[],grpNull,objNull]],
    ["_afterDropCode",{},["",{}]],
    ["_hoverHeight",20,[123]]
];


/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if !(["ace_fastroping"] call KISKA_fnc_isPatchLoaded) exitWith {
    ["ace_fastroping is required for this function",true] call KISKA_fnc_log;

};

if (isNull _vehicle) exitWith {
    ["_vehicle is null!",true] call KISKA_fnc_log;

};

[_vehicle] call ace_fastroping_fnc_equipFRIES;
if !([_vehicle] call ace_fastroping_fnc_canPrepareFRIES) exitWith {
    [[typeOf _vehicle," is not configured for ACE FRIES system!"],true] call KISKA_fnc_log;

};

if (_dropPosition isEqualType objNull) then {
    _dropPosition = getPosASL _dropPosition;
};

_hoverHeight = _hoverHeight max 5;
_hoverHeight = _hoverHeight min 25;

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
			_unitsToDeployFiltered pushBack _x;
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
private _hoverPosition = _dropPosition vectorAdd [0,0,_hoverHeight];
private _hoverPosition_AGL = ASLToAGL _hoverPosition;
private _pilot = driver _vehicle;

private _vehicleGroup = group (commander _vehicle);
_vehicleGroup allowFleeing 0;

private _pilot = driver _vehicle;
_pilot setSkill 1;
_pilot move (ASLToATL _hoverPosition);

// guides helicopter to drop position
[
    {
        params ["_args", "_id"];
        _args params [
            "_vehicle",
            "_hoverPosition_AGL",
            "_pilot",
            "_hoverPosition"
        ];

        if (
            alive _vehicle AND
            alive _pilot AND
            !isNil {_vehicle getVariable "ACE_Rappelling"}
        ) then {
            private _currentVehiclePosition_AGL = ASLToAGL (getPosASL _vehicle);
    		private _distanceToHoverPosition = _currentVehiclePosition_AGL distance _hoverPosition_AGL;

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


                if ( _distanceToHoverPosition <= 15 ) then {
        			_velocityMagnitude = (_distanceToHoverPosition / 10) * 5;

        		};

        		private _currentVelocity = velocity _vehicle;
        		_currentVelocity = _currentVelocity vectorAdd (( _currentVehiclePosition_AGL vectorFromTo _hoverPosition_AGL ) vectorMultiply _velocityMagnitude);
        		_currentVelocity = (vectorNormalized _currentVelocity) vectorMultiply ( (vectorMagnitude _currentVelocity) min _velocityMagnitude );
        		_vehicle setVelocity _currentVelocity;
            };

        } else {
            [_id] call CBA_fnc_removePerFrameHandler;

        };
    },
    0.05,
    [_vehicle, _hoverPosition_AGL, _pilot, _hoverPosition]
] call CBA_fnc_addPerFrameHandler;


/* ----------------------------------------------------------------------------
    Monitor drop for completion
---------------------------------------------------------------------------- */
[
    {
        params ["_vehicle","_hoverPosition_AGL","_pilot","",""];
        if (!alive _vehicle) exitWith {true};
        if (!alive _pilot) exitWith {true};
        private _currentVehiclePosition_AGL = ASLToAGL (getPosASL _vehicle);

        (speed _vehicle < (2.5 * 3.6))
        AND
        {
            (_hoverPosition_AGL distance2d _currentVehiclePosition_AGL) < 100
        }
        AND
        {
            (_hoverPosition_AGL vectorDiff _currentVehiclePosition_AGL) select 2 < 25
        }
    },
    {
        params ["_vehicle","","_pilot","_unitsToDeploy","_afterDropCode"];

        if (alive _vehicle AND (alive _pilot)) then {
            [_vehicle, _unitsToDeploy] call KISKA_fnc_ACE_deployFastRope;
        };


        private _id = [
            _vehicle,
            "KISKA_ACE_fastRopeFinished",
            {
                params ["_vehicle"];
                [_vehicle,"KISKA_ACE_fastRopeFinished",_thisScriptedEventHandler] call BIS_fnc_removeScriptedEventHandler;

                _vehicle setVariable ["ACE_Rappelling",nil];

                private _codeVar = "KISKA_ACE_fastRopeFinished_afterDropCode_" + (str _thisScriptedEventHandler);
                private _afterDropCode = _vehicle getVariable [_codeVar,{}];

                if (_afterDropCode isNotEqualTo {}) then {
                    _this call _afterDropCode;
                    _vehicle setVariable [_codeVar,nil];
                };
            }
        ] call BIS_fnc_addScriptedEventHandler;

        if (_afterDropCode isNotEqualTo {}) then {
            _vehicle setVariable ["KISKA_ACE_fastRopeFinished_afterDropCode_" + (str _id),_afterDropCode];
        };
    },
    [_vehicle,_hoverPosition_AGL,_pilot,_unitsToDeploy,_afterDropCode]
] call CBA_fnc_waitUntilAndExecute;
