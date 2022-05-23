/* ----------------------------------------------------------------------------
Function: KISKA_fnc_dropOff

Description:
	Tells a vehicle to move to a position and then drop off the specified units.

Parameters:
	0: _vehicle : <OBJECT> - The vehicle that will drop of units
    1: _dropOffPosition : <OBJECT or ARRAY> - The position to drop units off, can be object or position array
    2: _unitsToDropOff : <GROUP, ARRAY, or OBJECT> - The units to drop off
    3: _completionRadius : <NUMBER> - The radius at which the waypoint is complete and the units can disembark from the _dropOffPosition, -1 for exact placement
	4: _speed : <STRING> - The for the driver group to move at
	5: _codeOnComplete : <CODE> - Code to run upon completion of disembark (unscheduled)
        Params:
        0: <OBJECT> - The vehicle that will drop of units
        1: <ARRAY> - The units dropped off at this location

Returns:
	NOTHING

Examples:
    (begin example)
		[
            myVehicle,
            myPosition,
            player
        ] call KISKA_fnc_dropOff;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_dropOff";

params [
	["_vehicle",objNull,[objNull]],
	["_dropOffPosition",objNull,[[],objNull]],
    ["_unitsToDropOff",[],[[],grpNull,objNull]],
	["_completionRadius",10,[123]],
	["_speed","NORMAL",[""]],
	["_codeOnComplete",{},[{}]]
];

if (isNull _vehicle) exitWith {
    ["_vehicle is null, exiting...",true] call KISKA_fnc_log;
    nil
};

private _driver = driver _vehicle;
if !(alive _driver) exitWith {
    ["_driver is null or dead, exiting...",true] call KISKA_fnc_log;
    nil
};

private _positionIsObject = _dropOffPosition isEqualType objNull;
if (_positionIsObject AND (isNull _dropOffPosition)) exitWith {
    ["_dropOffPosition is null, exiting...",true] call KISKA_fnc_log;
    nil
};

if (_positionIsObject) then {
    _dropOffPosition = getPosATL _dropOffPosition;
};


/* ----------------------------------------------------------------------------
    Verify _unitsToDropOff parameter
---------------------------------------------------------------------------- */
if (_unitsToDropOff isEqualTo []) exitWith {
	["_unitsToDropOff is empty, exiting...",true] call KISKA_fnc_log;
	nil
};

if (_unitsToDropOff isEqualTypeAny [objNull,grpNull] AND {isNull _unitsToDropOff}) exitWith {
	["_unitsToDropOff isNull, exiting...",true] call KISKA_fnc_log;
	nil
};

if (_unitsToDropOff isEqualType grpNull) then {
	_unitsToDropOff = units _unitsToDropOff;
};

if (_unitsToDropOff isEqualType objNull) then {
	_unitsToDropOff = [_unitsToDropOff];
};

private _unitsToDropOffFiltered = [];

if (_unitsToDropOff isEqualType []) then {
	_unitsToDropOff apply {
		if (_x isEqualType grpNull) then {
			_unitsToDropOffFiltered append (units _x);
		};

		if (_x isEqualType objNull) then {
			_unitsToDropOffFiltered pushBack _x;
		};
	};
};


/* ----------------------------------------------------------------------------
    Main Function
---------------------------------------------------------------------------- */
private _driverGroup = group _driver;
_driverGroup setSpeedMode _speed;
// disable HC transfer while driving
[_driverGroup,true] call KISKA_fnc_ACEX_setHCTransfer;

[
    _vehicle,
    _unitsToDropOffFiltered,
    _codeOnComplete,
    _completionRadius,
    _dropOffPosition,
    _driver,
    _driverGroup
] spawn {
	params [
		"_vehicle",
		"_unitsToDropOffFiltered",
		"_codeOnComplete",
		"_completionRadius",
		"_dropOffPosition",
		"_driver",
        "_driverGroup"
	];


	// Need to wait for driver to be ready to move
    private _driver = driver _vehicle;
    waitUntil {
        if !(alive _driver) exitWith {true};
        sleep 0.1;
        unitReady _driver;
    };

    if (_driver in _vehicle) then {
        _driverGroup move _dropOffPosition;
    };

	waitUntil {
		if (
            _vehicle distance _dropOffPosition <= _completionRadius OR
            !(alive _vehicle) OR
            (isNull (driver _vehicle) OR
            {!(_driver in _vehicle)})
        ) exitWith {true};

		sleep 1;
		false
	};

	if (alive _vehicle) then {
		[["_vehicle ",_vehicle," has reached its destination"],false] call KISKA_fnc_log;

		_unitsToDropOffFiltered apply {
            [_x,_vehicle] remoteExec ["leaveVehicle",_x];
			[_x,_vehicle] remoteExec ["moveOut",_x];
            sleep 0.5;
		};

        waitUntil {
            if (
                !alive _vehicle OR
                {(_unitsToDropOffFiltered findIf {_x in _vehicle}) < 0}
            ) exitWith {true};

            sleep 1;
            false
        };
	};

	// enable HC transfer
	[_driverGroup,false] call KISKA_fnc_ACEX_setHCTransfer;

	if (_codeOnComplete isNotEqualTo {}) then {
        [
    		_codeOnComplete,
    		[_vehicle,_unitsToDropOffFiltered]
    	] call CBA_fnc_directCall;
	};
};

nil
