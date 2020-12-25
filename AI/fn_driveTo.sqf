/* ----------------------------------------------------------------------------
Function: KISKA_fnc_driveTo

Description:
	Units will drive to point and get out of vehicle.

Parameters:
	0: _crew : <GROUP, ARRAY, or OBJECT> - The units to move into the vehicle and drive
	1: _vehicle : <OBJECT> - The vehicle to put units into
	2: _dismountPoint : <OBJECT or ARRAY> - The position to move to, can be object or position array
	3: _completionRadius : <NUMBER> - The radius at which the waypoint is complete and the units can disembark from the _dismountPoint, -1 for exact placement
	3: _codeOnComplete : <CODE> - Code to run upon completion of disembark, passed args is the vehicle (OBJECT) and crew (ARRAY)

Returns:
	BOOL

Examples:
    (begin example)

		[_group1, _vehicle, myDismountPoint] call KISKA_fnc_driveTo;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_driveTo"
scriptName SCRIPT_NAME;

params [
	["_crew",[],[[],grpNull,objNull]],
	["_vehicle",objNull,[objNull]],
	["_dismountPoint",objNull,[[],objNull]],
	["_completionRadius",10,[123]],
	["_speed","NORMAL",[""]],
	["_codeOnComplete",{},[{}]]
];

if ((_crew isEqualTypeAny [grpNull,objNull] AND {isNull _crew}) OR {_crew isEqualTo []}) exitWith {
	[SCRIPT_NAME,["_crew for",_vehicle,"is undefined"],true,true] call KISKA_fnc_log;
	false
};

if (isNull _vehicle) exitWith {
	[SCRIPT_NAME,["_vehicle",_vehicle,"is null"],true,true] call KISKA_fnc_log;
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
{
	if !(_x in _vehicleCrew) then {
		if (_forEachIndex isEqualTo 0) then {
			_driverGroup = group _x;
			[_x,_vehicle] remoteExecCall ["moveInDriver",_x];
		} else {
			_x moveInAny _vehicle;
		};
	};

} forEach _crew;

[_driverGroup] call CBA_fnc_clearWaypoints;


[_driverGroup,_dismountPoint,-1,"MOVE","UNCHANGED","NO CHANGE",_speed,"NO CHANGE","",[0,0,0],_completionRadius] call CBA_fnc_addWaypoint;


[
	1,
	{
		params ["_vehicle","_crew","_codeOnComplete"];
		
		[SCRIPT_NAME,["_vehicle",_vehicle,"has reached its destination"]] call KISKA_fnc_log;

		_crew apply {
			[_x,_vehicle] remoteExecCall ["leaveVehicle",_x];
		};

		if !(_codeOnComplete isEqualTo {}) then {	
			[_vehicle,_crew] call _codeOnComplete;
		};
	},
	{((_this select 0) distance (_this select 4)) <= (_this select 3)},
	[_vehicle,_crew,_codeOnComplete,_completionRadius,_dismountPoint]
] call KISKA_fnc_waitUntil;


true