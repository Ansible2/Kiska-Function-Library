/* ----------------------------------------------------------------------------
Function: KISKA_fnc_attack

Description:
	Modified version of CBA_fnc_taskAttack,
	Now allows setting of different behaviour and combatMode

Parameters:

	0: _group <GROUP or OBJECT> - Unit(s) to attack
	1: _position <OBJECT, LOCATION, GROUP, or ARRAY> - The position to attack
	2: _behaviour <BOOL> - What behaviour will the attacker(s) have
	2: _combatMode <BOOL> - What combatMode will the attacker(s) have
	2: _radius <BOOL> - Radius for waypoint placement
	2: _override <BOOL> - Clear units current waypoints

Returns:
	NOTHING

Examples:
    (begin example)

		[group1,attackPosition,"COMBAT","RED"] call KISKA_fnc_attack;

    (end)

Author:
	Rommel,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_group",grpNull,[objNull,grpNull]],
	["_position",objNull,[[],objNull,locationNull,grpNull]], 
	["_behaviour","COMBAT",[""]],
	["_combatMode","RED",[""]],
	["_radius", -1,[123]], 
	["_override",false,[true]]
];

_group = _group call CBA_fnc_getGroup;
if !(local _group) exitWith {}; // Don't create waypoints on each machine

// Allow TaskAttack to override other set waypoints
if (_override) then {
	[_group] call CBA_fnc_clearWaypoints;
    
	(units _group) apply {
		_x enableAI "PATH";
	};
};

[_group, _position, _radius, "SAD", _behaviour, _combatMode] call CBA_fnc_addWaypoint;