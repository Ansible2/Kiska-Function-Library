/* ----------------------------------------------------------------------------
Function: KISKA_fnc_driveTo

Description:
	Units will drive to point and get out of vehicle

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

params [
	["_crew",[],[[],grpNull,objNull]],
	["_vehicle",objNull,[objNull]],
	["_dismountPoint",objNull,[[],objNull]],
	["_completionRadius",10,[123]],
	["_speed","NORMAL",[""]],
	["_codeOnComplete",{},[{}]]
];

if ((_crew isEqualTypeAny [grpNull,objNull] AND {isNull _crew}) OR {_crew isEqualTo []}) exitWith {
	"_crew is undefined" call BIS_fnc_error;
	false
};

if (isNull _vehicle) exitWith {
	"_vehicle isNull" call BIS_fnc_error;
	false
};


if (_crew isEqualType grpNull) then {
	_crew = units _crew;
};
if (_crew isEqualType objNull) then {
	_crew = [_crew];
};


private "_driverGroup";
{
	if !(_x in (crew _vehicle)) then {
		if (_forEachIndex isEqualTo 0) then {
			_driverGroup = group _x;
			_x moveInDriver _vehicle;
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

		_crew apply {
			[_x,_vehicle] remoteExec ["leaveVehicle",_x];
		};

		if !(_codeOnComplete isEqualTo {}) then {	
			[_vehicle,_crew] call _codeOnComplete;
		};
	},
	{((_this select 0) distance (_this select 4)) <= (_this select 3)},
	[_vehicle,_crew,_codeOnComplete,_completionRadius,_dismountPoint]
] call KISKA_fnC_waitUntil;

true