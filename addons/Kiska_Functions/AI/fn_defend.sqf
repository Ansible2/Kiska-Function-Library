/* ----------------------------------------------------------------------------
Function: KISKA_fnc_defend

Description:
	A function for a group to defend a parsed location. Should be ran locally.

	Units will mount nearby static machine guns and garrison in nearby buildings.
	10% chance to patrol the radius unless specified differently (100% when no available building positions).
	0% chance to hold defensive positions in combat unless specified differently.

Modifications:
	Accounted for doMove command's inability to use z-axis

Parameters:
	0: _group <GROUP or OBJECT> - The group to do the defending
	1: _position <OBJECT, LOCATION, GROUP, or ARRAY> - centre of area to defend <ARRAY, OBJECT, LOCATION, GROUP> (Default: _group)
	2: _radius <NUMBER> - radius of area to defend <NUMBER> (Default: 50)
	3: _threshold <NUMBER> - minimum building positions required to be considered for garrison <NUMBER> (Default: 3)
	4: _patrol <NUMBER or BOOL> - chance for each unit to patrol instead of garrison, true for default, false for 0% <NUMBER, BOOLEAN> (Default: 0.1)
	5: _hold <NUMBER or BOOL> - chance for each unit to hold their garrison in combat, true for 100%, false for 0% <NUMBER, BOOLEAN> (Default: 0)

Returns:
	NOTHING

Examples:
    (begin example)
		[this] call KISKA_fnc_defend
    (end)

Author:
	Rommel,
	Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_defend";


params [
	["_group",grpNull,[grpNull,objNull]],
	["_position",[],[[],objNull,grpNull,locationNull],3],
	["_radius", 50, [0]],
	["_threshold", 3, [0]],
	["_patrol", 0.1, [true, 0]],
	["_hold", 0, [true, 0]]
];

// Input validation stuff here
_group = _group call CBA_fnc_getGroup;
// Don't create waypoints on each machine
if !(local _group) exitWith {
	[["Found that ",_group," was not local, exiting..."],true] call KISKA_fnc_log;
	nil
};

_position = [_position, _group] select (_position isEqualTo []);
_position = _position call CBA_fnc_getPos;

if (_patrol isEqualType true) then {
	_patrol = [0, 0.1] select _patrol;
};

if (_hold isEqualType true) then {
	_hold = [0,1] select _hold;
};

// Start of the actual function
[_group] call CBA_fnc_clearWaypoints;

private _statics = _position nearObjects ["StaticWeapon", _radius];
private _buildings = _position nearObjects ["Building", _radius];

// Filter out occupied statics
_statics = _statics select {locked _x != 2 && {(_x emptyPositions "Gunner") > 0}};

// Filter out buildings below the size threshold (and store positions for later use)
_buildings = _buildings select {
	private _positions = _x buildingPos -1;

	if (isNil {_x getVariable "CBA_taskDefend_positions"}) then {
		_x setVariable ["CBA_taskDefend_positions", _positions];
	};

	count (_positions) >= _threshold
};

// If patrolling is enabled then the leader must be free to lead it
private _units = units _group;
if (_patrol > 0 && {count _units > 1}) then {
	_units deleteAt (_units find (leader _group));
};


_units apply {
	// 31% chance to occupy nearest free static weapon
	if ((random 1 < 0.31) && { !(_statics isEqualto []) }) then {
		_x assignAsGunner (_statics deleteAt 0);
		[_x] orderGetIn true;
	} else {
		// Respect chance to patrol, or force if no building positions left
		if !((_buildings isEqualto []) || { (random 1 < _patrol) }) then {
			private _building = selectRandom _buildings;
			private _array = _building getVariable ["CBA_taskDefend_positions", []];

			if !(_array isEqualTo []) then {
				private _pos = _array deleteAt (floor (random (count _array)));

				// If building positions are all taken remove from possible buildings
				if (_array isEqualTo []) then {
					_buildings deleteAt (_buildings find _building);
					_building setVariable ["CBA_taskDefend_positions", nil];
				} else {
					_building setVariable ["CBA_taskDefend_positions", _array];
				};

				// Wait until AI is in position then force them to stay
				[_x, _pos, _hold] spawn {
					params ["_unit", "_pos", "_hold"];
					if (surfaceIsWater _pos) exitwith {};

					_unit doMove _pos;
					waituntil {unitReady _unit};
					// doMove does not accout for height of a position, so we force it the AI there
					if !((getPosATL _unit) isEqualTo _pos) then {
						_unit setPosATL _pos;
					};

					if (random 1 < _hold) then {
						_unit disableAI "PATH";
					} else {
						doStop _unit;
					};
				/*
					[
						{unitReady (_this select 0)},
						{
							params [
								["_unit",objNull,[objNull]],
								["_pos",[0,0,0],[[]]],
								["_hold", 0, [true, 0]]
							];

							if !((getPosATL _unit) isEqualTo _pos) then {
								_unit setPosATL _pos;
							};

							if (random 1 < _hold) then {
								_unit disableAI "PATH";
							} else {
								doStop _unit;
							};
						},
						[_unit,_pos,_hold]
					] call CBA_fnc_waitUntilAndExecute;
				*/

					// This command causes AI to repeatedly attempt to crouch when engaged
					// If ever fixed by BI then consider uncommenting
					// _unit setUnitPos "UP";
				};
			};
		};
	};
};

// Unassigned (or combat reacted) units will patrol
[_group, _position, _radius, 5, "sad", "safe", "red", "limited"] call CBA_fnc_taskPatrol;


nil
