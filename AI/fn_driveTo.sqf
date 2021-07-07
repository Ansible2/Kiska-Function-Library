/* ----------------------------------------------------------------------------
Function: KISKA_fnc_driveTo

Description:
	Units will drive to point and get out of vehicle.

Parameters:
	0: _crew : <GROUP, ARRAY, or OBJECT> - The units to move into the vehicle and drive
	1: _vehicle : <OBJECT> - The vehicle to put units into
	2: _dismountPoint : <OBJECT or ARRAY> - The position to move to, can be object or position array
	3: _completionRadius : <NUMBER> - The radius at which the waypoint is complete and the units can disembark from the _dismountPoint, -1 for exact placement
	4: _speed : <STRING> - The waypoint speed
	5: _codeOnComplete : <CODE> - Code to run upon completion of disembark, passed args is the vehicle (OBJECT), crew (ARRAY), and crew groups (ARRAY)

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
	["_codeOnComplete",{},[{}]]
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


private "_driverGroup";
private _vehicleCrew = crew _vehicle;
private _crewGroups = [];
{
	if !(_x in _vehicleCrew) then {
		// take the first man and put him in the driver seat
		if (_forEachIndex isEqualTo 0) then {
			_driverGroup = group _x;
			[_x,_vehicle] remoteExecCall ["moveInDriver",_x];

		} else {
			_x moveInAny _vehicle;
			_crewGroups pushBackUnique (group _x);

		};

	};
} forEach _crew;
// disable HC transfer while driving
[_driverGroup,false] call KISKA_fnc_ACEX_setHCTransfer;

[_driverGroup] call CBA_fnc_clearWaypoints;
[_driverGroup,_dismountPoint,-1,"MOVE","UNCHANGED","NO CHANGE",_speed,"NO CHANGE","",[0,0,0],_completionRadius] call CBA_fnc_addWaypoint;

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

	waitUntil {
		if (_vehicle distance _dismountPoint <= _completionRadius) exitWith {true};
		sleep 1;
		false
	};

	[["_vehicle ",_vehicle," has reached its destination"],false] call KISKA_fnc_log;

	_crew apply {
		[_x,_vehicle] remoteExecCall ["leaveVehicle",_x];
	};

	// enable HC transfer
	[_driverGroup,true] call KISKA_fnc_ACEX_setHCTransfer;

	if (_codeOnComplete isNotEqualTo {}) then {
		[_vehicle,_crew,_crewGroups] call _codeOnComplete;
	};
};


true
