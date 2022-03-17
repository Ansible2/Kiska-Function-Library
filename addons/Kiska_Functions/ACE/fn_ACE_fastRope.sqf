/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_fastRope

Description:


Parameters:
	0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _dropPosition <ARRAY> - The position to drop the units off at; Z coordinate
        matters

Returns:
	NOTHING

Examples:
    (begin example)
		[
            _vehicle,
            [0,0,0]
		] call KISKA_fnc_ACE_fastRope;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_fastRope";

if (!canSuspend) exitWith {
    ["Must be run in a scheduled environment! Exiting to scheduled..."] call KISKA_fnc_log;
    _this spawn KISKA_fnc_ACE_fastRope;
};

params [
    ["_vehicle",objNull,[objNull]],
    ["_dropPosition",[],[[],objNull]],
    ["_dropArray",[],[[],grpNull,objNull]]
];

if !(["ace_main"] call KISKA_fnc_isPatchLoaded) exitWith {
    ["ace_main is required for this function",true] call KISKA_fnc_log;

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

/* ----------------------------------------------------------------------------
    Verify _dropArray
---------------------------------------------------------------------------- */
if (_dropArray isEqualTo []) exitWith {
	["_dropArray is empty",true] call KISKA_fnc_log;
	false
};

if (_dropArray isEqualTypeAny [objNull,grpNull] AND {isNull _dropArray}) exitWith {
	["_dropArray isNull",true] call KISKA_fnc_log;
	false
};

if (_dropArray isEqualType grpNull) then {
	_dropArray = units _dropArray;
};

if (_dropArray isEqualType objNull) then {
	_dropArray = [_dropArray];
};

private _dropArrayFiltered = [];
if (_dropArray isEqualType []) then {
	_dropArray apply {
		if (_x isEqualType grpNull) then {
			_dropArrayFiltered append (units _x);
		};

		if (_x isEqualType objNull) then {
			_dropArrayFiltered pushBack _x;
		};
	};
};

if (_dropArrayFiltered isEqualTo []) then {
    _dropArrayFiltered = _dropArray;
};


/* ----------------------------------------------------------------------------

---------------------------------------------------------------------------- */
_vehicle setVariable ["ACE_Rappelling",true];
private _hoverPosition = _dropPosition vectorAdd [0,0,20];
private _hoverPosition_AGL = ASLToAGL _hoverPosition;
private _pilot = driver _vehicle;

private _vehicleGroup = group (commander _vehicle);
_vehicleGroup allowFleeing 0;

private _pilot = driver _vehicle;
_pilot setSkill 1;
_pilot move (ASLToATL _hoverPosition);
/* _vehicle flyInHeight 20; */

[
    {
        params ["_args", "_id"];
        _args params [
            "_vehicle",
            "_hoverPosition_AGL",
            "_pilot"
        ];

        if (
            alive _vehicle AND
            alive _pilot AND
            !isNil {_vehicle getVariable "ACE_Rappelling"}
        ) then {
            private _currentVehiclePosition_AGL = ASLToAGL (getPosASL _vehicle);
    		private _distanceToHoverPosition = _currentVehiclePosition_AGL distance _hoverPosition_AGL;

            hint str _distanceToHoverPosition;
            if ( _distanceToHoverPosition <= 400 ) then {
                /* private _velocityMagnitude = (_distanceToHoverPosition / 10) max 20; */
                private _velocityMagnitude = 15;
                if ( _distanceToHoverPosition <= 15 ) then {
        			_velocityMagnitude = (_distanceToHoverPosition / 10) * _velocityMagnitude;

        		};

        		private _currentVelocity = velocity _vehicle;
        		_currentVelocity = _currentVelocity vectorAdd (( _currentVehiclePosition_AGL vectorFromTo _hoverPosition_AGL ) vectorMultiply _velocityMagnitude);
        		_currentVelocity = (vectorNormalized _currentVelocity) vectorMultiply ( (vectorMagnitude _currentVelocity) min _velocityMagnitude );
        		_vehicle setVelocity _currentVelocity;
                hintSilent str _currentVelocity;
            };

        } else {
            hint "step 1";
            [_id] call CBA_fnc_removePerFrameHandler;

        };
    },
    0.05,
    [_vehicle, _hoverPosition_AGL, _pilot]
] call CBA_fnc_addPerFrameHandler;


[
    {
        params ["_vehicle","_hoverPosition_AGL","_pilot"];
        if (!alive _vehicle) exitWith {true};
        if (!alive _pilot) exitWith {true};
        private _currentVehiclePosition_AGL = ASLToAGL (getPosASL _vehicle);

        (speed _vehicle < 0.05)
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
        hint "step 2";

        params ["_vehicle","","_pilot"];
        if (alive _vehicle AND alive _pilot) then {
            [_vehicle] call ace_fastroping_fnc_deployAI;
        };

        [_vehicle] spawn {
            params ["_vehicle"];

            waitUntil {
                sleep 1;
                ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isNotEqualTo [])
            };

            waitUntil {
                sleep 1;
                ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isEqualTo [])
            };

            _vehicle setVariable ["ACE_Rappelling",nil];

            hint "step 3";
        };
    },
    [_vehicle,_hoverPosition_AGL,_pilot]
] call CBA_fnc_waitUntilAndExecute;
