/* ----------------------------------------------------------------------------
Function: KISKA_fnc_patrolSpecific

Description:
	Creates a cycle of waypoints for a patrol using a predetermined set of possible points

Parameters:
	0: _group <GROUP or OBJECT> - The group or unit to give waypoints to
	1: _numWaypoints <NUMBER> - The number of waypoints
	2: _postions <ARRAY> - An array of possible positions to patrol between, can be either positions or objects

	(Optional)
	3: _random <BOOL> - Should waypoints be randomized from _positions array
	4: _behaviour <STRING> - setWaypointBehaviour, takes "UNCHANGED", "SAFE", "COMBAT", "AWARE", "CARELESS", and "STEALTH"
	5: _speed <STRING> - setWaypointSpeed, takes "UNCHANGED", "LIMITED", "NORMAL", and "FULL"
	6: _combatMode <STRING> - setWaypointCombatMode, takes "NO CHANGE", "BLUE", "GREEN", "WHITE", "YELLOW", and "RED"
	7: _formation <STRING> - setWaypointFormation, takes "NO CHANGE", "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", and "DIAMOND"

Returns:
	<BOOL> - True if units will patrol, false if problem encountered

Examples:
    (begin example)
		[_group,5,_positionsArray] call KISKA_fnc_patrolSpecific;
    (end)

Author:
	Ansible2 // Cipher,
	Spectre
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_patrolSpecific";

params [
	["_group",grpNull,[grpNull,objNull]],
	["_numWaypoints",5,[1]],
	["_positions",[],[[]]],
	["_random",true,[true]],
	["_behaviour","SAFE",[""]],
	["_speed","LIMITED",[""]],
	["_combatMode","RED",[""]],
	["_formation","STAG COLUMN",[""]]
];

if !(local _group) exitWith {
	[["Found that ",_group," was not local, exiting..."],true] call KISKA_fnc_log;
	false
};

if (isNull _group) exitwith {
	[["Found that ",_group," was null, exiting..."],true] call KISKA_fnc_log;
	false
};

if (_numWaypoints < 2) exitwith {
	[[_numWaypoints," is not above 2, needs to be atleast 2, exiting..."],true] call KISKA_fnc_log;
	false
};

if (_positions isEqualTo []) exitwith {
	[[_positions,". No positions passed, exiting..."],true] call KISKA_fnc_log;
	false
};

if ((count _positions) < 1) exitwith {
	[[_positions,". Need more positions to be passed. Exiting..."],true] call KISKA_fnc_log;
	false
};

if (_group isEqualType objNull) then {
	_group = group _group;
};


[_group] call CBA_fnc_clearWaypoints;

private "_cyclePosition";

for "_i" from 1 to _numWaypoints do {
	private "_selectedPosition";
	private "_waypoint";

	if (_random) then {
		_selectedPosition = selectRandom _positions;
		_positions deleteAt (_positions find _selectedPosition);
		_waypoint = _group addWaypoint [_selectedPosition,0];
	} else {
		_selectedPosition = _positions select (_i - 1);
		_waypoint = _group addWaypoint [_selectedPosition,0];
	};

	if (_i isEqualTo 1) then {
		_cycleposition = _selectedPosition;
	};

	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointBehaviour _behaviour;
	_waypoint setWaypointFormation _formation;
	_waypoint setWaypointSpeed _speed;
	_waypoint setWaypointCombatMode _combatMode;
};


_cycleWaypoint = _group addWaypoint [_cyclePosition,0];
_cycleWaypoint setWaypointType "CYCLE";


true
