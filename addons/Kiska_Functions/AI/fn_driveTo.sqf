/* ----------------------------------------------------------------------------
Function: KISKA_fnc_driveTo

Description:
	Units will drive to point and get out of vehicle.

Parameters:
	0: _crew : <GROUP, ARRAY, or OBJECT> - The units to move into the vehicle and drive
	1: _vehicle : <OBJECT> - The vehicle to put units into
	2: _dismountPoint : <OBJECT or ARRAY> - The position to move to, can be object or position array
	3: _completionRadius : <NUMBER> - The radius at which the waypoint is complete and the units can disembark from the _dismountPoint, -1 for exact placement
	4: _speed : <STRING> - The for the driver group to move at
	5: _codeOnComplete : <CODE, STRING, or ARRAY> - Code to run upon completion of disembark. See KISKA_fnc_callBack
		Params:
			0: <OBJECT> - The vehicle, crew (ARRAY), and crew groups (ARRAY)
			1: <ARRAY (of OBJECTs)> - The crew of the vehicle
			2: <ARRAY (of GROUPs)> - All the groups that are in the vehicle crew

Returns:
	<BOOL> - false if encountered error, true if success

Examples:
    (begin example)
		[_group1, _vehicle, myDismountPoint] call KISKA_fnc_driveTo;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_driveTo";

params [
	["_crew",[],[[],grpNull,objNull]],
	["_vehicle",objNull,[objNull]],
	["_dismountPoint",objNull,[[],objNull]],
	["_completionRadius",10,[123]],
	["_speed","NORMAL",[""]],
	["_codeOnComplete",{},[{},"",[]]]
];

if ((_crew isEqualTypeAny [grpNull,objNull] AND {isNull _crew}) OR {_crew isEqualTo []}) exitWith {
	[["_crew for ",_vehicle," is undefined"],true] call KISKA_fnc_log;
	false
};

if (isNull _vehicle) exitWith {
	["_vehicle is null",true] call KISKA_fnc_log;
	false
};


if (_crew isEqualType grpNull) then {
	_crew = units _crew;
};
if (_crew isEqualType objNull) then {
	_crew = [_crew];
};


private _vehicleCrew = crew _vehicle;
private _crewGroups = [];
{
	if !(_x in _vehicleCrew) then {
		_x moveInAny _vehicle;
	};
	_crewGroups pushBackUnique (group _x);
} forEach _crew;

private _driverGroup = group (driver _vehicle);
_driverGroup setSpeedMode _speed;


// disable HC transfer while driving
[_driverGroup,true] call KISKA_fnc_ACEX_setHCTransfer;

/* [_driverGroup] call CBA_fnc_clearWaypoints; */
/* [_driverGroup,_dismountPoint,-1,"MOVE","UNCHANGED","NO CHANGE",_speed,"NO CHANGE","",[0,0,0],_completionRadius] call CBA_fnc_addWaypoint; */

// position loop
[_vehicle,_crew,_codeOnComplete,_completionRadius,_dismountPoint,_driverGroup,_crewGroups] spawn {
	params [
		"_vehicle",
		"_crew",
		"_codeOnComplete",
		"_completionRadius",
		"_dismountPoint",
		"_driverGroup",
		"_crewGroups"
	];


	// Need to wait for driver to be ready to move
    private _driver = driver _vehicle;
    waitUntil {
        if (!alive _driver OR {!(_driver in _vehicle)}) exitWith {true};
        sleep 0.1;
        unitReady _driver;
    };

	private _dismountPointPos = [_dismountPoint, getPosATL _dismountPoint] select (_dismountPoint isEqualType objNull);
    _driverGroup move _dismountPointPos;

	waitUntil {
		if (
			_vehicle distance _dismountPoint <= _completionRadius OR
			 !(alive _vehicle) OR
			 (isNull (driver _vehicle) OR
			  {!(_driver in _vehicle)})
		) exitWith {true};

		sleep 1;
		false
	};

	if (alive _vehicle) then {
		[["_vehicle ",_vehicle," has reached its destination"],false] call KISKA_fnc_log;

		_crew apply {
			[_x,_vehicle] remoteExecCall ["leaveVehicle",_x];
		};
	};

	// enable HC transfer
	[_driverGroup,false] call KISKA_fnc_ACEX_setHCTransfer;

	[
		[_vehicle,_crew,_crewGroups],
		_codeOnComplete
	] call KISKA_fnc_callBack;

};


true
