/* ----------------------------------------------------------------------------
Function: KISKA_fnc_airAssault

Description:
	Gives air unit with troops onboard waypoints to follow to land and unload troops. 
	Also creates the ability to have the unit "wave off" and loiter until told to come in to land.

Parameters:
	0: _aircraftGroup : <GROUP> - The transport aircraft's (crew) group
	1: _movePoints : <ARRAY> - An array of objects and/or positions for which the aircraft will move to in sequential order
	2: _landPostition : <OBJECT or ARRAY> - Position to drop off troops
	3: _loiterPosition : <OBJECT or ARRAY> - Wave off position to loiter
	4: _deletionPosition : <OBJECT or ARRAY> - Final position to delete the aircraft and crew

Returns:
	Nothing

Examples:
    (begin example)

		[airCraftGroupName,[waypointPos_1, waypointPos_2, waypointPos_3], LandingPos ,LoiterPos , FinalDeletetionPos] spawn KISKA_fnc_airAssault;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */

if (!isServer) exitWith {};

if (!canSuspend) exitWith {
	"Must be run in scheduleded envrionment" call BIS_fnc_error;
};

params [
	["_aircraftGroup",grpNull,[grpNull]],
	["_movePoints",[],[]],
	["_landPostition",objNull,[objNull,[]]],
	["_loiterPosition",objNull,[[],objNull]],
	["_deletionPosition",objNull,[[],objNull]]
];

if (isNull _aircraftGroup) exitWith {};

if (isNil "waveOff") then {
	_aircraftGroup setVariable ["waveOff",false,true];
};

if (isNil "waveOffCalled") then {
	missionNamespace setVariable ["waveOffCalled",false,true];
};

fn_move = {
	params [
		["_WP",objNull,[objNull]],
		["_aircraftGroup",grpNull,[grpNull]]
	];

	private _movePoint = _aircraftGroup addWaypoint [_WP,1];

	_movepoint setWaypointType "MOVE";
	_movePoint setWaypointBehaviour "SAFE";
	_movepoint setWaypointCombatMode "RED";
	_movePoint setWaypointSpeed "full";

	_movePoint
};

fn_loiter = {
	params [
		["_aircraftGroup",grpNull,[grpNull]],
		["_loiterPosition",objNull,[objNull]],
		["_landPostition",objNull,[objNull]],
		["_deletionPosition",objNull]
	];

	{
		deleteWaypoint ((waypoints _aircraftGroup) select 0);
	} count (waypoints _aircraftGroup) > 0;

	private _loiterPoint = _aircraftGroup addWaypoint [_loiterPosition,-1,0];
	_loiterPoint setWaypointType "LOITER";
	_loiterPoint setWaypointLoiterType "Circle";
	_aircraftGroup setCurrentWaypoint _loiterPoint;

	[
		{!(missionNamespace getVariable "waveOffCalled")}, 
		{
			{
				deleteWaypoint ((waypoints _aircraftGroup) select 0);
			} count (waypoints _aircraftGroup) > 0;
			[_this select 0,_this select 1,_this select 2] call fn_land;
		}, 
		[_aircraftGroup,_landPostition,_deletionPosition]
	] call CBA_fnc_waitUntilAndExecute;

};

fn_land = {
	params [
		["_aircraftGroup",grpNull,[grpNull]],
		["_landPostition",objNull,[objNull]],
		["_deletionPosition",objNull]
	];
	
	if (!(_aircraftGroup getVariable "waveOff")) then {
		private _unloadWP = _aircraftGroup addWaypoint [_landPostition,20];
		_unloadWP setWaypointType "TR UNLOAD";
		_unloadWP setWaypointSpeed "LIMITED";
		
	} else {
		private _unloadWP = _aircraftGroup addWaypoint [_landPostition,20];
		_unloadWP setWaypointType "TR UNLOAD";
		_unloadWP setWaypointSpeed "LIMITED";

		private _deletePoint = _aircraftGroup addWaypoint [getPosASL _deletionPosition,-1];
		
		_deletePoint setWaypointType "MOVE";
		_deletePoint setWaypointBehaviour "SAFE";
		_deletePoint setWaypointCombatMode "RED";
		_deletePoint setWaypointSpeed "FULL";

		_aircraftGroup setCurrentWaypoint _unloadWP;
	};
};

// waitUntil the waveOffCalled variable is created to make the move markers
[
	{!(isNil "waveOffCalled")}, 
	{	
		private _aircraftGroup = _this select 0;
		private _movePoints = _this select 1; 

		// create move waypoints
		if (count _movePoints > 0) then {
			{
				_movePoint = [_x,_aircraftGroup] call fn_Move;
			} forEach _movePoints;
		};

	}, 
	[_aircraftGroup,_movePoints]
] call CBA_fnc_waitUntilAndExecute;


// waitUntil the move markers are all made to add the land waypoint
[
	{(count (waypoints (_this select 0)) == (count (_this select 1)) + 1)}, 
	{	
		private _aircraftGroup = _this select 0;
		private _landPostition = _this select 2; 
		private _deletionPosition = _this select 3;

		[_aircraftGroup,_landPostition,_deletionPosition] call fn_Land;
	}, 
	[_aircraftGroup,_movePoints,_landPostition,_deletionPosition]
] call CBA_fnc_waitUntilAndExecute;

// Start loop that will either exit once landed (and troops unloaded) or if wave off called

while {true} do {
	if (missionNamespace getVariable "waveOffCalled") exitWith {
		[_aircraftGroup,_loiterPosition,_landPostition,_deletionPosition] call fn_loiter;
		_aircraftGroup setVariable ["waveOff",true,true];
	};

	if (((leader _aircraftGroup) distance _landPostition) < 25) exitWith {

		private _deletePoint = _aircraftGroup addWaypoint [getPosASL _deletionPosition,-1];
		
		_deletePoint setWaypointType "MOVE";
		_deletePoint setWaypointBehaviour "SAFE";
		_deletePoint setWaypointCombatMode "RED";
		_deletePoint setWaypointSpeed "FULL";
	};

	sleep 1;
};

/*
[
	{	
		private _aircraftGroup = (_this select 0) select 0;
		private _loiterPosition = (_this select 0) select 1;
		private _landPostition = (_this select 0) select 2;
		private _deletionPosition = (_this select 0) select 3;

		private _perFrameEH = _this select 1;

		if (missionNamespace getVariable "waveOffCalled") exitWith {
			[_aircraftGroup,_loiterPosition,_landPostition,_deletionPosition] call fn_loiter;
			_aircraftGroup setVariable ["waveOff",true,true];
			
			[_perFrameEH] call CBA_fnc_removePerFrameHandler;
		};

		if (((leader _aircraftGroup) distance _landPostition) < 25) exitWith {

			private _deletePoint = _aircraftGroup addWaypoint [getPosASL _deletionPosition,-1];
			
			_deletePoint setWaypointType "MOVE";
			_deletePoint setWaypointBehaviour "SAFE";
			_deletePoint setWaypointCombatMode "RED";
			_deletePoint setWaypointSpeed "FULL";

			[_perFrameEH] call CBA_fnc_removePerFrameHandler;
		};
	}, 
	1, 
	[_aircraftGroup,_loiterPosition,_landPostition,_deletionPosition]
] call CBA_fnc_addPerFrameHandler;
*/